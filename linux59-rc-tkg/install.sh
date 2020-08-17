#!/bin/bash

msg2() {
 echo -e " \033[1;34m->\033[1;0m \033[1;1m$1\033[1;0m" >&2
}

error() {
 echo -e " \033[1;31m==> ERROR: $1\033[1;0m" >&2
}

warning() {
 echo -e " \033[1;33m==> WARNING: $1\033[1;0m" >&2
}

plain() {
 echo "$1" >&2
}

# alias plain=echo
set -e

_where=`pwd`
srcdir="$_where"

_cpu_opt_patch_link="https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.8%2B.patch"  

source customization.cfg

if [ "$1" != "install" ] && [ "$1" != "config" ] && [ "$1" != "uninstall" ]; then
  echo "Command not recognised, options are:
        - config : shallow clones the linux 5.7.x git tree into the folder linux-5.7, then applies on it the extra patches and prepares the .config file by copying the one from the current linux system in /boot/config-`uname -r` and updates it. 
        - install : [Debian-like only (Debian, Ubuntu, Pop_os!...)], does the config step, proceeds to compile, then prompts to install
        - uninstall : [Debian-like only (Debian, Ubuntu, Pop_os!...)], lists the installed custom kernels through this script, then prompts for which one to uninstall."
  exit 0
fi

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

_misc_adds="false" # We currently don't want this enabled on non-Arch

if [ "$1" = "install" ] || [ "$1" = "config" ]; then

  source linux*-tkg-config/prepare

  if [ $1 = "install" ] && [ "$_distro" != "Ubuntu" ]; then
    msg2 "Variable \"_distro\" in \"customization.cfg\" hasn't been set to \"Ubuntu\""
    msg2 "This script can only install custom kernels for Ubuntu and Debian derivatives. Exiting..."
    exit 0
  fi

  if [ "$_distro" = "Ubuntu" ]; then
    msg2 "Installing dependencies"
    sudo apt install git build-essential kernel-package fakeroot libncurses5-dev libssl-dev ccache bison flex
  else
    msg2 "Dependencies are unknown for the target linux distribution."
  fi

  # Force prepare script to avoid Arch specific commands if the user didn't change _distro from "Arch"
  if [ "$1" = "config" ]; then
    _distro=""
  fi

  if [ -d linux-${_basekernel}.orig ]; then
    rm -rf linux-${_basekernel}.orig
  fi

  if [ -d linux-${_basekernel} ]; then
    msg2 "Reseting files in linux-$_basekernel to their original state and getting latest updates"
    cd "$_where"/linux-${_basekernel}
    git checkout --force linux-$_basekernel.y
    git clean -f -d -x
    git pull
    msg2 "Done" 
    cd "$_where"
  else
    msg2 "Shallow git cloning linux $_basekernel"
    git clone --branch linux-$_basekernel.y --single-branch --depth=1 https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-${_basekernel}
    msg2 "Done"
  fi

  # Define current kernel subversion
  if [ -z $_kernel_subver ]; then
    cd "$_where"/linux-${_basekernel}
    _kernelverstr=`git describe`
    _kernel_subver=${_kernelverstr:5}
    cd "$_where"
  fi


  # Run init script that is also run in PKGBUILD, it will define some env vars that we will use
  _tkg_initscript

  cd "$_where"
  msg2 "Downloading Graysky2's CPU optimisations patch"
  wget "$_cpu_opt_patch_link"

  # Follow Ubuntu install isntructions in https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

  # cd in linux folder, copy Ubuntu's current config file, update with new params
  cd "$_where"/linux-${_basekernel}

  msg2 "Copying current kernel's config and running make oldconfig..."
  cp /boot/config-`uname -r` .config
  yes '' | make oldconfig
  msg2 "Done"

  # apply linux-tkg patching script
  _tkg_srcprep

  msg2 "Configuration done."
fi

if [ "$1" = "install" ]; then

  # Use custom compiler paths if defined
  if [ -n "${CUSTOM_GCC_PATH}" ]; then
    PATH=${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}
  fi

  if [ "$_force_all_threads" = "true" ]; then
    _thread_num=`nproc`
  else
    _thread_num=`expr \`nproc\` / 4`
    if [ "$_thread_num" = "0" ]; then
      _thread_num=1
    fi
  fi

  # ccache
  if [ "$_noccache" != "true" ]; then
    if [ "$_distro" = "Ubuntu" ] && dpkg -l ccache > /dev/null; then
      export PATH="/usr/lib/ccache/bin/:$PATH"
      export CCACHE_SLOPPINESS="file_macro,locale,time_macros"
      export CCACHE_NOHASHDIR="true"
      msg2 'ccache was found and will be used'
    fi
  fi

  _kernel_flavor="${_kernel_localversion}"
  if [ -z $_kernel_localversion ]; then
    _kernel_flavor="tkg-${_cpusched}"
  fi

  if [ "$_distro" = "Ubuntu" ]; then
    if make -j ${_thread_num} deb-pkg LOCALVERSION=-${_kernel_flavor}; then
      msg2 "Building successfully finished!"
      read -p "Do you want to install the new Kernel ? y/[n]: " _install
      if [[ $_install =~ [yY] ]] || [[ $_install =~ [yY] ]] || [ $_install = "yes" ] || [ $_install = "Yes" ]; then
        cd "$_where"
        _kernelname=$_basekernel.$_kernel_subver-$_kernel_flavor
        _headers_deb=linux-headers-${_kernelname}*.deb
        _image_deb=linux-image-${_kernelname}_*.deb
        
        sudo dpkg -i $_headers_deb $_image_deb

        # Add to the list of installed kernels, used for uninstall
        if ! { [ -f installed-kernels ] && grep -Fxq "$_kernelname" installed-kernels; }; then
          echo $_kernelname >> installed-kernels 
        fi   
      fi
    fi
  fi
fi

if [ "$1" = "uninstall" ]; then

  cd "$_where"

  if [ ! -f installed-kernels ] || [ ! -s installed-kernels ]; then
    echo "No custom kernel has been installed yet"
    exit 0
  fi

  i=1
  declare -a _custom_kernels
  msg2 "Installed custom kernel versions: "
  while read p; do
    echo "    $i) $p"
    _custom_kernels+=($p)
    i=$((i+1))
  done < installed-kernels
  
  i=$((i-1))
  _delete_index=0
  read -p "Which one would you like to delete ? [1-$i]: " _delete_index

  if [ $_delete_index -ge 1 ] && [ $_delete_index -le $i ]; then
    _delete_index=$((_delete_index-1))
    sudo dpkg -r linux-headers-${_custom_kernels[$_delete_index]} linux-image-${_custom_kernels[$_delete_index]}
  fi

  rm -f installed-kernels
  i=0
  for kernel in "${_custom_kernels[@]}"; do 
    if [ $_delete_index != $i ]; then
      echo "$kernel" >> installed-kernels
    fi
    i=$((i+1))
  done

fi
