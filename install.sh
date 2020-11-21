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

# Stop the script at any ecountered error
set -e

_where=`pwd`
srcdir="$_where"

source customization.cfg

source linux-tkg-config/prepare 

if [ "$1" != "install" ] && [ "$1" != "config" ] && [ "$1" != "uninstall-help" ]; then
  msg2 "Argument not recognised, options are:
        - config : shallow clones the linux ${_basekernel}.x git tree into the folder linux-src-git, then applies on it the extra patches and prepares the .config file 
                   by copying the one from the current linux system in /boot/config-`uname -r` and updates it. 
        - install : [RPM and DEB based distros only], does the config step, proceeds to compile, then prompts to install
        - uninstall-help : [RPM and DEB based distros only], lists the installed kernels in this system, then gives a hint on how to uninstall them manually."
  exit 0
fi

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

_misc_adds="false" # We currently don't want this enabled on non-Arch

if [ "$1" = "install" ] || [ "$1" = "config" ]; then

  if [ -z $_distro ] && [ "$1" = "install" ]; then
    _distro_prompt
  fi

  if [ "$1" = "config" ]; then
    _distro="Unknown"
  fi

  # Run init script that is also run in PKGBUILD, it will define some env vars that we will use
  _tkg_initscript

  if [[ $1 = "install" && "$_distro" != "Ubuntu" && "$_distro" != "Debian" &&  "$_distro" != "Fedora" && "$_distro" != "Suse" ]]; then 
    msg2 "Variable \"_distro\" in \"customization.cfg\" hasn't been set to \"Ubuntu\", \"Debian\",  \"Fedora\" or \"Suse\""
    msg2 "This script can only install custom kernels for RPM and DEB based distros, though only those keywords are permitted. Exiting..."
    exit 0
  fi

  # Install the needed dependencies if the user wants to install the kernel
  # Not needed if the user asks for install.sh config
  if [ $1 == "install" ]; then
    _install_dependencies
  fi

  # Force prepare script to avoid Arch specific commands if the user is using `config`
  if [ "$1" = "config" ]; then
    _distro=""
  fi

  # Git clone (if necessary) and checkout the asked branch by the user
  _linux_git_branch_checkout
  
  cd "$_where"

  msg2 "Downloading Graysky2's CPU optimisations patch"

  case "$_basever" in
    "54")
    opt_ver="4.19-v5.4"
    ;;
    "57")
    opt_ver="5.7%2B"
    ;;
    "58")
    opt_ver="5.8%2B"
    ;;
    "59")
    opt_ver="5.8%2B"
    ;;
    "510")
    opt_ver="5.8%2B"
    ;;
  esac

  wget "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v${opt_ver}.patch" 

  # Follow Ubuntu install isntructions in https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

  # cd in linux folder, copy Ubuntu's current config file, update with new params
  cd "$_where"/linux-src-git

  if ( msg2 "Trying /boot/config-* ..." && cp /boot/config-`uname -r` .config ) || ( msg2 "Trying /proc/config.gz ..." && zcat --verbose /proc/config.gz > .config ); then
    msg2 "Copying current kernel's config and running make oldconfig..."
  else
    msg2 "Current kernel config not found! Falling back to default..."
  fi
  if [ "$_distro" = "Debian" ]; then #Help Debian cert problem.
    sed -i -e 's#CONFIG_SYSTEM_TRUSTED_KEYS="debian/certs/test-signing-certs.pem"#CONFIG_SYSTEM_TRUSTED_KEYS=""#g' .config
  fi
  yes '' | make ${llvm_opt} oldconfig
  msg2 "Done"

  # apply linux-tkg patching script
  _tkg_srcprep

  # source cpuschedset since _cpusched isn't set
  source "$srcdir"/cpuschedset

  # Uppercase characters are not allowed in source package name for debian based distros
  if [ "$_distro" = "Debian" ] || [ "$_distro" = "Ubuntu" ] && [ "$_cpusched" = "MuQSS" ]; then
    _cpusched="muqss"
  fi

  msg2 "Configuration done."
fi

if [ "$1" = "install" ]; then

  # Use custom compiler paths if defined
  if [ "$_compiler_name" = "-llvm" ] && [ -n "${CUSTOM_LLVM_PATH}" ]; then
    PATH="${CUSTOM_LLVM_PATH}/bin:${CUSTOM_LLVM_PATH}/lib:${CUSTOM_LLVM_PATH}/include:${PATH}"
  elif [ -n "${CUSTOM_GCC_PATH}" ]; then
    PATH="${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}"
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

    if [ "$_distro" = "Ubuntu" ] || [ "$_distro" = "Debian" ]; then
      export PATH="/usr/lib/ccache/bin/:$PATH"
    elif [ "$_distro" = "Fedora" ] || [ "$_distro" = "Suse" ]; then
      export PATH="/usr/lib64/ccache/:$PATH" 
    fi

    export CCACHE_SLOPPINESS="file_macro,locale,time_macros"
    export CCACHE_NOHASHDIR="true"
    msg2 'ccache was found and will be used'

  fi

  if [ -z $_kernel_localversion ]; then
    _kernel_flavor="tkg-${_cpusched}${_compiler_name}"
  else
    _kernel_flavor="tkg-${_kernel_localversion}"
  fi

  # Setup kernel_subver variable
  if [[ "$_sub" = rc* ]]; then
    # if an RC version, subver will always be 0
    _kernel_subver=0
  else
    _kernel_subver="${_sub}"
  fi

  if [ "$_distro" = "Ubuntu" ]  || [ "$_distro" = "Debian" ]; then

    if make ${llvm_opt} -j ${_thread_num} deb-pkg LOCALVERSION=-${_kernel_flavor}; then
      msg2 "Building successfully finished!"

      cd "$_where"

      # Create DEBS folder if it doesn't exist
      mkdir -p DEBS
      
      # Move rpm files to RPMS folder inside the linux-tkg folder
      mv "$_where"/*.deb "$_where"/DEBS/

      read -p "Do you want to install the new Kernel ? y/[n]: " _install
      if [[ $_install =~ [yY] ]] || [ $_install = "yes" ] || [ $_install = "Yes" ]; then
        cd "$_where"
        if [[ "$_sub" = rc* ]]; then
          _kernelname=$_basekernel.$_kernel_subver-$_sub-$_kernel_flavor
        else
          _kernelname=$_basekernel.$_kernel_subver-$_kernel_flavor
        fi
        _headers_deb="linux-headers-${_kernelname}*.deb"
        _image_deb="linux-image-${_kernelname}_*.deb"
        _kernel_devel_deb="linux-libc-dev_${_kernelname}*.deb"
        
        cd DEBS
        sudo dpkg -i $_headers_deb $_image_deb $_kernel_devel_deb
      fi
    fi

  elif [[ "$_distro" = "Fedora" ||  "$_distro" = "Suse" ]]; then

    # Replace dashes with underscores, it seems that it's being done by binrpm-pkg
    # Se we can actually refer properly to the rpm files.
    _kernel_flavor=${_kernel_flavor//-/_}

    if [[ "$_sub" = rc* ]]; then
      _extra_ver_str="_${_sub}_${_kernel_flavor}"
    else
      _extra_ver_str="_${_kernel_flavor}"
    fi

    if RPMOPTS='--define "_topdir ~/.cache/linux-tkg-rpmbuild"' make ${llvm_opt} -j ${_thread_num} rpm-pkg EXTRAVERSION="${_extra_ver_str}"; then
      msg2 "Building successfully finished!"

      cd "$_where"

      # Create RPMS folder if it doesn't exist
      mkdir -p RPMS
      
      # Move rpm files to RPMS folder inside the linux-tkg folder
      mv ~/.cache/linux-tkg-rpmbuild/RPMS/x86_64/*tkg* "$_where"/RPMS/

      rm -rf ~/.cache/linux-tkg-rpmbuild

      read -p "Do you want to install the new Kernel ? y/[n]: " _install
      if [ "$_install" = "y" ] || [ "$_install" = "Y" ] || [ "$_install" = "yes" ] || [ "$_install" = "Yes" ]; then
        
        if [[ "$_sub" = rc* ]]; then
          _kernelname=$_basekernel.${_kernel_subver}_${_sub}_$_kernel_flavor
        else
          _kernelname=$_basekernel.${_kernel_subver}_$_kernel_flavor
        fi
        _headers_rpm="kernel-headers-${_kernelname}*.rpm"
        _kernel_rpm="kernel-${_kernelname}*.rpm"
        _kernel_devel_rpm="kernel-devel-${_kernelname}*.rpm"
        
        cd RPMS
        if [ "$_distro" = "Fedora" ]; then
          sudo dnf install $_headers_rpm $_kernel_rpm $_kernel_devel_rpm
        elif [ "$_distro" = "Suse" ]; then
          msg2 "Some files from 'linux-glibc-devel' will be replaced by files from the custom kernel-hearders package"
          msg2 "To revert back to the original kernel headers do 'sudo zypper install -f linux-glibc-devel'" 
          sudo zypper install --replacefiles --allow-unsigned-rpm $_headers_rpm $_kernel_rpm $_kernel_devel_rpm
        fi
        
        msg2 "Install successful" 
      fi
    fi
  fi
fi

if [ "$1" = "uninstall-help" ]; then

  if [ -z $_distro ]; then
    _distro_prompt
  fi

  cd "$_where"
  msg2 "List of installed custom tkg kernels: "

  if [ "$_distro" = "Ubuntu" ]; then
    dpkg -l "*tkg*" | grep "linux.*tkg"
    dpkg -l "*linux-libc-dev*" | grep "linux.*tkg"
    msg2 "To uninstall a version, you should remove the linux-image, linux-headers and linux-libc-dev associated to it (if installed), with: "
    msg2 "      sudo apt remove linux-image-VERSION linux-headers-VERSION linux-libc-dev-VERSION"
    msg2 "       where VERSION is displayed in the lists above, uninstall only versions that have \"tkg\" in its name"
  elif [ "$_distro" = "Fedora" ]; then
    dnf list --installed kernel*
    msg2 "To uninstall a version, you should remove the kernel, kernel-headers and kernel-devel associated to it (if installed), with: "
    msg2 "      sudo dnf remove --noautoremove kernel-VERSION kernel-devel-VERSION kernel-headers-VERSION"
    msg2 "       where VERSION is displayed in the second column"
  elif [ "$_distro" = "Suse" ]; then
    zypper packages --installed-only | grep "kernel.*tkg"
    msg2 "To uninstall a version, you should remove the kernel, kernel-headers and kernel-devel associated to it (if installed), with: "
    msg2 "      sudo zypper remove --no-clean-deps kernel-VERSION kernel-devel-VERSION kernel-headers-VERSION"
    msg2 "       where VERSION is displayed in the second to last column"
  fi

fi
