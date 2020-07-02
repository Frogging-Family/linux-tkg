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

source customization.cfg
# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values." && msg2 ""
fi

source linux57-tkg-config/prepare

_define_vars

if [ "$_distro" != "Ubuntu" ]; then 
  msg2 "This install script works only on Ubuntu, aborting..."
  exit 0
fi

if [ -f linux-${pkgver}.tar.xz ]; then  
  msg2 "linux-${pkgver}.tar.xz already available locally."
else
  msg2 "linux-${pkgver}.tar.xz not available locally, downloading..."
  wget ${source[0]}
fi


if [ -f linux-${pkgver}.tar.sign ]; then 
  rm -f linux-${pkgver}.tar.sign
fi

wget ${source[1]}
gpg2 --locate-keys torvalds@kernel.org gregkh@kernel.org

if ! [ -f linux-${pkgver}.tar ]; then
  msg2 "Decompressing archive into tar file ..."
  xz -d -k linux-${pkgver}.tar.xz 
  msg2 "Done."
fi


echo "Verifying signature"
if gpg2 --verify linux-${pkgver}.tar.sign ; then 
  msg2 "Signature good!"
else  
  rm -rf linux-${pkgver}.tar.xz linux-${pkgver}.tar.sign linux-src linux-${pkgver}.tar
  msg2 "Wrong linux archive signature, please re-run the installer."
  exit 0
fi

msg2 "Decompressing tar archive to folder ..."
rm -rf linux-${pkgver}
tar -xf linux-${pkgver}.tar
msg2 "Done"

# Run init script that is also run in PKGBUILD, it will define some env vars that we will use
source linux57-tkg-config/prepare
_tkg_initscript

# Follow Ubuntu install isntructions in https://wiki.ubuntu.com/KernelTeam/GitKernelBuild

# cd in linux folder, copy Ubuntu's current config file, update with new params
cd linux-${pkgver}

msg2 "Copying current kernel's config and running make oldconfig..."
cp /boot/config-`uname -r` .config
yes '' | make oldconfig
msg2 "Done"

# apply linux-tkg patching script
_tkg_srcprep