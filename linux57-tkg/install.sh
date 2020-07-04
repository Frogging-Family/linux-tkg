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

source customization.cfg

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

source linux57-tkg-config/prepare

_define_vars

if [ "$_distro" != "Ubuntu" ]; then 
  msg2 "This install script works only on Ubuntu, aborting..."
  exit 0
fi

if [ -d linux-5.7.orig ]; then
  rm -rf linux-5.7.orig
fi

if [ -d linux-${_basekernel} ]; then
  msg2 "Reseting files in linux-$_basekernel to their original state and getting latest updates"
  cd linux-${_basekernel}
  git checkout --force linux-$_basekernel.y
  git clean -f -d -x
  git pull
  msg2 "Done"
  if ! [ -z $_kernel_subver ]; then
    msg2 "Reverting to older subversion: ${_kernel_subver}"
    git checkout v$_basekernel.$_kernel_subver
    msg2 "Done"
  fi  
  cd ..
else
  msg2 "Shallow git cloning linux $_basekernel"
  git clone --branch linux-$_basekernel.y --single-branch --shallow-since=$_basever_date https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git linux-${_basekernel}
  if [ -n $_kernel_subver ]; then
    cd linux-${_basekernel}  
    git checkout v$_basekernel.$_kernel_subver
    cd ..
  fi  
fi

# Run init script that is also run in PKGBUILD, it will define some env vars that we will use
source linux57-tkg-config/prepare
_tkg_initscript

# Follow Ubuntu install isntructions in https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

# cd in linux folder, copy Ubuntu's current config file, update with new params
cd linux-${_basekernel}

msg2 "Copying current kernel's config and running make oldconfig..."
cp /boot/config-`uname -r` .config
yes '' | make oldconfig
msg2 "Done"

# apply linux-tkg patching script
_tkg_srcprep

# Use custom compiler paths if defined
if [ -n "${CUSTOM_GCC_PATH}" ]; then
  PATH=${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}
fi

if [ "$_force_all_threads" == "true" ]; then
  _thread_num=`nproc`
else
  _thread_num=`expr \`nproc\` / 4`
  if [ _thread_num == 0 ]; then
    _thread_num=1
  fi
fi

# ccache
if [ "$_noccache" != "true" ]; then
  if [ "$_distro" == "Ubuntu" ] && dpkg -l ccache > /dev/null; then
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

if [ "$_distro" == "Ubuntu" ]; then
  make -j ${_thread_num} deb-pkg LOCALVERSION=-${_kernel_flavor}
fi