#!/bin/bash

# Stop the script at any ecountered error
set -e

# save current environment before losing it to the script call
declare -p -x > current_env

# If current run is not using 'script' for logging, do it
if [[ "$_logging_use_script" =~ ^(Y|y|Yes|yes)$ && -z "$SCRIPT" ]]; then
  export SCRIPT=1
  /usr/bin/script -q -e -c "$0 $@" shell-output.log
  exit_status="$?"
  sed -i 's/\x1b\[[0-9;]*m//g' shell-output.log
  sed -i 's/\x1b(B//g' shell-output.log
  mv -f shell-output.log logs/shell-output.log.txt
  exit $exit_status
fi

###################### Definition of helper variables and functions

_where=`pwd`
srcdir="$_where"

# Command used for superuser privileges (`sudo`, `doas`, `su`)
if [ ! -x "$(command -v sudo)" ]; then
  if [ -x "$(command -v doas)" ]; then
    sudo() { doas "$@"; }
  elif [ -x "$(command -v su)" -a -x "$(command -v xargs)" ]; then
    sudo() { echo "$@" | xargs -I {} su -c '{}'; }
  fi
fi

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
 echo -e "$1" >&2
}

####################################################################

################### Config sourcing

source customization.cfg

if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

. current_env

source linux-tkg-config/prepare

####################################################################

_distro_prompt() {
  echo "Which linux distribution are you running ?"
  echo "if it's not on the list, chose the closest one to it: Fedora/Suse for RPM, Ubuntu/Debian for DEB"
  _prompt_from_array "Debian" "Fedora" "Suse" "Ubuntu" "Gentoo" "Generic"
  _distro="${_selected_value}"
}

_install_dependencies() {
  if [ "$_compiler_name" = "llvm" ]; then
    clang_deps="llvm clang lld"
  fi
  if [ "$_distro" = "Debian" -o "$_distro" = "Ubuntu" ]; then
    msg2 "Installing dependencies"
    sudo apt install bc bison build-essential ccache cpio fakeroot flex git kmod libelf-dev libncurses5-dev libssl-dev lz4 qtbase5-dev rsync schedtool wget zstd debhelper ${clang_deps} -y
  elif [ "$_distro" = "Fedora" ]; then
    msg2 "Installing dependencies"
    sudo dnf install perl bison ccache dwarves elfutils-devel elfutils-libelf-devel fedora-packager fedpkg flex gcc-c++ git grubby libXi-devel lz4 make ncurses-devel openssl openssl-devel perl-devel perl-generators pesign python3-devel qt5-qtbase-devel rpm-build rpmdevtools schedtool zstd bc rsync -y ${clang_deps} -y
  elif [ "$_distro" = "Suse" ]; then
    msg2 "Installing dependencies"
    sudo zypper install -y bc bison ccache dwarves elfutils flex gcc-c++ git libXi-devel libelf-devel libqt5-qtbase-common-devel libqt5-qtbase-devel lz4 make ncurses-devel openssl-devel patch pesign rpm-build rpmdevtools schedtool python3 rsync zstd ${clang_deps}
  fi
}

if [ "$1" != "install" ] && [ "$1" != "config" ] && [ "$1" != "uninstall-help" ]; then
  msg2 "Argument not recognised, options are:
        - config : interactive script that shallow clones the linux 5.x.y git tree into the folder \$_kernel_work_folder, then applies extra patches and prepares the .config file
                   by copying the one from the currently running linux system and updates it.
        - install : does the config step, proceeds to compile, then prompts to install
                    - 'DEB' distros: it creates .deb packages that will be installed then stored in the DEBS folder.
                    - 'RPM' distros: it creates .rpm packages that will be installed then stored in the RPMS folder.
                    - 'Generic' distro: it uses 'make modules_install' and 'make install', uses 'dracut' to create an initramfs, then updates grub's boot entry.
        - uninstall-help : [RPM and DEB based distros only], lists the installed kernels in this system, then gives hints on how to uninstall them manually."
  exit 0
fi

if [ "$1" = "install" ] || [ "$1" = "config" ]; then

  if [ -z "$_distro" ] && [ "$1" = "install" ]; then
    _distro_prompt
  fi

  if [ "$1" = "config" ]; then
    _distro="Unknown"
  fi

  # Run init script that is also run in PKGBUILD, it will define some env vars that we will use
  _tkg_initscript

  if [[ "${_compiler}" = "llvm" && "${_distro}" =~ ^(Generic|Gentoo)$ && "${_libunwind_replace}" = "true" ]]; then
      export LDFLAGS_MODULE="-unwindlib=libunwind"
      export HOSTLDFLAGS="-unwindlib=libunwind"
  fi

  if [[ "$1" = "install" && ! "$_distro" =~ ^(Ubuntu|Debian|Fedora|Suse|Gentoo|Generic)$ ]]; then
    msg2 "Variable \"_distro\" in \"customization.cfg\" has been set to an unkown value. Prompting..."
    _distro_prompt
  fi

  # Install the needed dependencies if the user wants to install the kernel
  # Not needed if the user asks for install.sh config
  if [ "$1" == "install" ]; then
    _install_dependencies
  fi

  # Force prepare script to avoid Arch specific commands if the user is using `config`
  if [ "$1" = "config" ]; then
    _distro=""
  fi

  _tkg_srcprep

  _build_dir="$_kernel_work_folder_abs/.."

  # Uppercase characters are not allowed in source package name for debian based distros
  if [[ "$_distro" =~ ^(Debian|Ubuntu)$ && "$_cpusched" = "MuQSS" ]]; then
    _cpusched="muqss"
  fi

  msg2 "Configuration done."
fi

if [ "$1" = "install" ]; then

  if [ -e "${_where}/winesync.rules" ]; then
    msg2 "Installing udev rule for winesync"
    sudo cp "${_where}"/winesync.rules /etc/udev/rules.d/winesync.rules
    sudo chmod 644 /etc/udev/rules.d/winesync.rules

    msg2 "Adding winesync to '/etc/modules-load.d' for auto-loading by systemd - Password prompt incoming!"
    sudo sh -c 'echo "winesync" >/etc/modules-load.d/winesync.conf'
  fi

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
    export PATH="/usr/lib64/ccache/:/usr/lib/ccache/bin/:$PATH"

    export CCACHE_SLOPPINESS="file_macro,locale,time_macros"
    export CCACHE_NOHASHDIR="true"
    msg2 'Enabled ccache'
  fi

  if [ -z "$_kernel_localversion" ]; then
    if [ "$_preempt_rt" = "1" ]; then
      _kernel_flavor="tkg-${_cpusched}-rt${_compiler_name}"
    else
      _kernel_flavor="tkg-${_cpusched}${_compiler_name}"
    fi
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

  #_timed_build() {
    #_runtime=$( time ( schedtool -B -n 1 -e ionice -n 1 "$@" 2>&1 ) 3>&1 1>&2 2>&3 ) || _runtime=$( time ( "$@" 2>&1 ) 3>&1 1>&2 2>&3 ) - Bash 5.2 is broken https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1018727
  #}

  cd "$_kernel_work_folder_abs"

  msg2 "Add patched files to the diff.patch"
  git add .

  if [[ "$_distro" =~ ^(Ubuntu|Debian)$ ]]; then

    msg2 "Building kernel DEB packages"
    make ${llvm_opt} -j ${_thread_num} bindeb-pkg LOCALVERSION=-${_kernel_flavor}
    msg2 "Building successfully finished!"

    # Create DEBS folder if it doesn't exist
    cd "$_where"
    mkdir -p DEBS

    # Move deb files to DEBS folder inside the linux-tkg folder
    mv "$_build_dir"/*.deb "$_where"/DEBS/

    # Install only the winesync header in whatever kernel src there is, if there is
    if [ -e "${_where}/winesync.rules" ]; then
      sudo mkdir -p /usr/include/linux/
      # install winesync header
      sudo cp "$_kernel_work_folder_abs"/include/uapi/linux/winesync.h /usr/include/linux/winesync.h
    fi

    if [[ "$_install_after_building" = "prompt" ]]; then
      read -p "Do you want to install the new Kernel ? Y/[n]: " _install
    fi

    if [[ "$_install_after_building" =~ ^(Y|y|Yes|yes)$ || "$_install" =~ ^(Y|y|Yes|yes)$ ]]; then
      cd "$_where"
      if [[ "$_sub" = rc* ]]; then
        _kernelname=$_basekernel.$_kernel_subver-$_sub-$_kernel_flavor
      else
        _kernelname=$_basekernel.$_kernel_subver-$_kernel_flavor
      fi
      _headers_deb="linux-headers-${_kernelname}*.deb"
      _image_deb="linux-image-${_kernelname}_*.deb"

      cd DEBS
      sudo dpkg -i $_headers_deb $_image_deb
    fi

  elif [[ "$_distro" =~ ^(Fedora|Suse)$ ]]; then

    # Replace dashes with underscores, it seems that it's being done by binrpm-pkg
    # Se we can actually refer properly to the rpm files.
    _kernel_flavor=${_kernel_flavor//-/_}

    if [[ "$_sub" == rc* ]]; then
      _extra_ver_str="_${_sub}_${_kernel_flavor}"
    else
      _extra_ver_str="_${_kernel_flavor}"
    fi

    _fedora_work_dir="$_kernel_work_folder_abs/rpmbuild"

    msg2 "Building kernel RPM packages"
    RPMOPTS="--define '_topdir ${_fedora_work_dir}'" make ${llvm_opt} -j ${_thread_num} binrpm-pkg EXTRAVERSION="${_extra_ver_str}"
    msg2 "Building successfully finished!"

    # Create RPMS folder if it doesn't exist
    cd "$_where"
    mkdir -p RPMS

    # Move rpm files to RPMS folder inside the linux-tkg folder
    mv ${_fedora_work_dir}/RPMS/x86_64/*tkg* "$_where"/RPMS/

    # Install only the winesync header in whatever kernel src there is, if there is
    if [ -e "${_where}/winesync.rules" ]; then
      sudo mkdir -p /usr/include/linux/
      # install winesync header
      sudo cp "$_kernel_work_folder_abs"/include/uapi/linux/winesync.h /usr/include/linux/winesync.h
    fi

    if [[ "$_install_after_building" = "prompt" ]]; then
      read -p "Do you want to install the new Kernel ? Y/[n]: " _install
    fi

    if [[ "$_install_after_building" =~ ^(Y|y|Yes|yes)$ || "$_install" =~ ^(Y|y|Yes|yes)$ ]]; then

      if [[ "$_sub" = rc* ]]; then
        _kernelname=$_basekernel.${_kernel_subver}_${_sub}_$_kernel_flavor
      else
        _kernelname=$_basekernel.${_kernel_subver}_$_kernel_flavor
      fi

      _kernel_rpm="kernel-${_kernelname}*.rpm"
      # The headers are actually contained in the kernel-devel RPM and not the headers one...
      _kernel_devel_rpm="kernel-devel-${_kernelname}*.rpm"
      _kernel_syms_rpm="kernel-syms-${_kernelname}*.rpm"

      cd RPMS
      if [ "$_distro" = "Fedora" ]; then
        sudo dnf install $_kernel_rpm $_kernel_devel_rpm
      elif [ "$_distro" = "Suse" ]; then
        # It seems there is some weird behavior with relocking existing locks, so let's unlock first
        sudo zypper removelock kernel-default-devel kernel-default kernel-devel kernel-syms

        msg2 "Some files from 'linux-glibc-devel' will be replaced by files from the custom kernel-hearders package"
        msg2 "To revert back to the original kernel headers do 'sudo zypper install -f linux-glibc-devel'"
        sudo zypper install --oldpackage --allow-unsigned-rpm $_kernel_rpm $_kernel_devel_rpm $_kernel_syms_rpm

        # Let's lock post install
        warning "By default, system kernel updates will overwrite your custom kernel."
        warning "Adding a lock will prevent this but skip system kernel updates."
        msg2 "You can remove the lock if needed with 'sudo zypper removelock kernel-default-devel kernel-default kernel-devel kernel-syms'"
        read -p "Would you like to lock system kernel packages ? Y/[n]: " _lock
        if [[ "$_lock" =~ ^(Y|y|Yes|yes)$ ]]; then
          sudo zypper addlock kernel-default-devel kernel-default kernel-devel kernel-syms
        fi
      fi

      if [ "$_distro" = "Suse" ]; then
        msg2 "Creating initramfs"
        sudo dracut --force --hostonly ${_dracut_options} --kver $_kernelname
        msg2 "Updating GRUB"
        sudo grub2-mkconfig -o /boot/grub2/grub.cfg
      fi

      msg2 "Install successful"
    fi

  elif [[ "$_distro" =~ ^(Gentoo|Generic)$ ]]; then

    ./scripts/config --set-str LOCALVERSION "-${_kernel_flavor}"

    if [[ "$_sub" = rc* ]]; then
      _kernelname=$_basekernel.${_kernel_subver}-${_sub}-$_kernel_flavor
    else
      _kernelname=$_basekernel.${_kernel_subver}-$_kernel_flavor
    fi

    msg2 "Building kernel"
    make ${llvm_opt} -j ${_thread_num}
    msg2 "Build successful"

    if [ "$_STRIP" = "true" ]; then
      echo "Stripping vmlinux..."
      strip -v $STRIP_STATIC "vmlinux"
    fi

    _headers_folder_name="linux-$_kernelname"

    msg2 "Removing unneeded architectures..."
    for arch in arch/*/; do
      [[ $arch = */x86/ ]] && continue
      echo "Removing $(basename "$arch")"
      rm -r "$arch"
    done

    msg2 "Removing broken symlinks..."
    find -L . -type l -printf 'Removing %P\n' -delete

    msg2 "Removing loose objects..."
    find . -type f -name '*.o' -printf 'Removing %P\n' -delete

    msg2 "Stripping build tools..."
    while read -rd '' file; do
      case "$(file -bi "$file")" in
        application/x-sharedlib\;*)      # Libraries (.so)
          strip -v $STRIP_SHARED "$file" ;;
        application/x-archive\;*)        # Libraries (.a)
          strip -v $STRIP_STATIC "$file" ;;
        application/x-executable\;*)     # Binaries
          strip -v $STRIP_BINARIES "$file" ;;
        application/x-pie-executable\;*) # Relocatable binaries
          strip -v $STRIP_SHARED "$file" ;;
      esac
    done < <(find . -type f -perm -u+x ! -name vmlinux -print0)

    echo -e "\n\n"

    msg2 "The installation process will run the following commands:"
    echo "    # copy the patched and compiled sources to /usr/src/$_headers_folder_name"
    echo "    sudo make modules_install"
    echo "    sudo make install"
    echo "    sudo dracut --force --hostonly ${_dracut_options} --kver $_kernelname"
    echo "    sudo grub-mkconfig -o /boot/grub/grub.cfg"

    msg2 "Note: Uninstalling requires manual intervention, use './install.sh uninstall-help' for more information."
    read -p "Continue ? Y/[n]: " _continue

    if ! [[ "$_continue" =~ ^(Y|y|Yes|yes)$ ]];then
      exit 0
    fi

    msg2 "Copying files over to /usr/src/$_headers_folder_name"
    if [ -d "/usr/src/$_headers_folder_name" ]; then
      msg2 "Removing old folder in /usr/src/$_headers_folder_name"
      sudo rm -rf "/usr/src/$_headers_folder_name"
    fi
    sudo cp -R . "/usr/src/$_headers_folder_name"
    sudo rm -rf "/usr/src/$_headers_folder_name"/.git*
    cd "/usr/src/$_headers_folder_name"

    msg2 "Installing modules"
    if [ "$_STRIP" = "true" ]; then
      sudo make modules_install INSTALL_MOD_STRIP="1"
    else
      sudo make modules_install
    fi
    msg2 "Removing modules from source folder in /usr/src/${_kernel_src_gentoo}"
    sudo find . -type f -name '*.ko' -delete
    sudo find . -type f -name '*.ko.cmd' -delete

    msg2 "Installing kernel"
    sudo make install

    if [ "$_distro" = "Gentoo" ]; then

      msg2 "Selecting the kernel source code as default source folder"
      sudo ln -sfn "/usr/src/$_headers_folder_name" "/usr/src/linux"

      msg2 "Rebuild kernel modules with \"emerge @module-rebuild\" ?"
      if [ "$_compiler" = "llvm" ];then
        warning "Building modules with LLVM/Clang is mostly unsupported OOTB by \"emerge @module-rebuild\" except for Nvidia 465.31+"
        warning "     Manually setting \"CC=clang\" for some modules may work if you haven't used LTO"
      fi

      read -p "Y/[n]: " _continue
      if [[ "$_continue" =~ ^(Y|y|Yes|yes)$ ]];then
        sudo emerge @module-rebuild --keep-going
      fi

    else

      msg2 "Creating initramfs"
      sudo dracut --force --hostonly ${_dracut_options} --kver $_kernelname
      msg2 "Updating GRUB"
      sudo grub-mkconfig -o /boot/grub/grub.cfg

    fi

  fi
fi

if [ "$1" = "uninstall-help" ]; then

  if [ -z $_distro ]; then
    _distro_prompt
  fi

  cd "$_where"

  if [[ "$_distro" =~ ^(Ubuntu|Debian)$ ]]; then
    msg2 "List of installed custom tkg kernels: "
    dpkg -l "*tkg*" | grep "linux.*tkg"
    dpkg -l "*linux-libc-dev*" | grep "linux.*tkg"
    msg2 "To uninstall a version, you should remove the linux-image, linux-headers and linux-libc-dev associated to it (if installed), with: "
    msg2 "      sudo apt remove linux-image-VERSION linux-headers-VERSION linux-libc-dev-VERSION"
    msg2 "       where VERSION is displayed in the lists above, uninstall only versions that have \"tkg\" in its name"
    msg2 "Note: linux-libc-dev packages are no longer created and installed, you can safely remove any remnants."
  elif [ "$_distro" = "Fedora" ]; then
    msg2 "List of installed custom tkg kernels: "
    dnf list --installed | grep -i "tkg"
    msg2 "To uninstall a version, you should remove the kernel, kernel-headers and kernel-devel associated to it (if installed), with: "
    msg2 "      sudo dnf remove --noautoremove kernel-VERSION kernel-devel-VERSION kernel-headers-VERSION"
    msg2 "       where VERSION is displayed in the second column"
    msg2 "Note: kernel-headers packages are no longer created and installed, you can safely remove any remnants."
  elif [ "$_distro" = "Suse" ]; then
    msg2 "List of installed custom tkg kernels: "
    zypper packages --installed-only | grep "kernel.*tkg"
    msg2 "To uninstall a version, you should remove the kernel, kernel-headers and kernel-devel associated to it (if installed), with: "
    msg2 "      sudo zypper remove --no-clean-deps kernel-VERSION kernel-devel-VERSION kernel-headers-VERSION"
    msg2 "       where VERSION is displayed in the second to last column"
    msg2 "Note: kernel-headers packages are no longer created and installed, you can safely remove any remnants."
  elif [[ "$_distro" =~ ^(Generic|Gentoo)$ ]]; then
    msg2 "Folders in /lib/modules :"
    ls /lib/modules
    msg2 "Files in /boot :"
    ls /boot
    msg2 "To uninstall a kernel version installed through install.sh with 'Generic' as a distro:"
    msg2 "  - Remove manually the corresponding folder in '/lib/modules'"
    msg2 "  - Remove manually the corresponding 'System.map', 'vmlinuz', 'config' and 'initramfs' in the folder :/boot"
    msg2 "  - Update the boot menu. e.g. 'sudo grub-mkconfig -o /boot/grub/grub.cfg'"
  fi

fi
