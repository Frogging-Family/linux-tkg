# Based on the file created for Arch Linux by:
# Tobias Powalowski <tpowa@archlinux.org>
# Thomas Baechler <thomas@archlinux.org>

# Contributor: Tk-Glitch <ti3nou at gmail dot com>

plain '       .---.`               `.---.'
plain '    `/syhhhyso-           -osyhhhys/`'
plain '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
plain '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
plain '   :syNNdhNNhssssssssssssssshNNhdNNys:'
plain '    /ssyhhhysssssssssssssssssyhhhyss/'
plain '    .ossssssssssssssssssssssssssssso.'
plain '   :sssssssssssssssssssssssssssssssss:'
plain '  /sssssssssssssssssssssssssssssssssss/'
plain ' :sssssssssssssoosssssssoosssssssssssss:'
plain ' osssssssssssssoosssssssoossssssssssssso'
plain ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
plain ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
plain '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
plain '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
plain '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
plain '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
plain '             `.-:///////:-.`'

_where="$PWD" # track basedir as different Arch based distros are moving srcdir around

source "$_where"/customization.cfg # load default configuration from file
source "$_where"/linux*-tkg-config/prepare

if [[ "$_sub" = rc* ]]; then
  _srcpath="linux-${_basekernel}-${_sub}"
else
  _srcpath="linux-${_basekernel}"
fi

_tkg_initscript

if [ -n "$_custom_pkgbase" ]; then
  pkgbase="${_custom_pkgbase}"
else
  pkgbase=linux"${_basever}"-tkg-"${_cpusched}"
fi
pkgname=("${pkgbase}" "${pkgbase}-headers")
pkgver="${_basekernel}"."${_sub}"
pkgrel=4
pkgdesc='Linux-tkg'
arch=('x86_64') # no i686 in here
url="http://www.kernel.org/"
license=('GPL2')
makedepends=('xmlto' 'docbook-xsl' 'kmod' 'inetutils' 'bc' 'libelf' 'pahole' 'patchutils' 'flex' 'python-sphinx' 'python-sphinx_rtd_theme' 'graphviz' 'imagemagick' 'git')
optdepends=('schedtool')
options=('!strip')
source=("https://www.kernel.org/pub/linux/kernel/v5.x/linux-${_basekernel}.tar.xz"
        "https://www.kernel.org/pub/linux/kernel/v5.x/patch-${pkgver}.xz"
        "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.8%2B.patch"
        'config.x86_64' # stock Arch config
        #'config_hardened.x86_64' # hardened Arch config
        90-cleanup.hook
        cleanup
        # ARCH Patches
        0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch
        # TkG
        0002-clear-patches.patch
        0003-glitched-base.patch
        0003-glitched-cfs.patch
        #0004-glitched-ondemand-muqss.patch
        #0004-glitched-muqss.patch
        #0004-5.8-ck1.patch
        0005-glitched-ondemand-pds.patch
        0005-glitched-pds.patch
        0005-v5.8_undead-pds099o.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.8-fsync.patch
        #0008-5.8-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.8-r1.patch
        0011-ZFS-fix.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
)
sha256sums=('e7f75186aa0642114af8f19d99559937300ca27acaf7451b36d4f9b0f85cf1f5'
            '8a385031e4e2b514d68590b20c0e22e3daf9d97bbfacd2ba131c8ea2e3449ccd'
            '5ab29eb64e57df83b395a29a6a4f89030d142feffbfbf73b3afc6d97a2a7fd12'
            '240321e752714a4b64c2aaf15a875866f24e7b66bbbe79042e0ee73d64849c38'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            'd02bf5ca08fd610394b9d3a0c3b176d74af206f897dee826e5cbaec97bb4a4aa'
            'd6cde733ad3bd8287528f69c16debfa75e7e43e8bb4c26a8ca9e1a3a7e303a02'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '7fd8e776209dac98627453fda754bdf9aff4a09f27cb0b3766d7983612eb3c74'
            '31b172eb6a0c635a8d64cc1c2e8181d9f928ee991bd44f6e556d1713b815f8d9'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'cd225e86d72eaf6c31ef3d7b20df397f4cc44ddd04389850691292cdf292b204'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            '965a517a283f265a012545fbb5cc9e516efc9f6166d2aa1baf7293a32a1086b7'
            '1656a20d3bab28c72e004778f77e880bba8d02eba8d18a81558cdc9d6733b1f1'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            '98311deeb474b39e821cd1e64198793d5c4d797155b3b8bbcb1938b7f11e8d74')

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  rm -rf $pkgdir # Nuke the entire pkg folder so it'll get regenerated clean on next build

  ln -s "${_where}/customization.cfg" "${srcdir}" # workaround

  cd "${srcdir}/${_srcpath}"

  _tkg_srcprep
}

build() {
  cd "${srcdir}/${_srcpath}"

  # Use custom compiler paths if defined
  if [ -n "${CUSTOM_GCC_PATH}" ]; then
    PATH=${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}
  fi

  if [ "$_force_all_threads" = "true" ]; then
    _force_all_threads="-j$((`nproc`*2))"
  else
    _force_all_threads="${MAKEFLAGS}"
  fi

  # ccache
  if [ "$_noccache" != "true" ] && pacman -Qq ccache &> /dev/null; then
    export PATH="/usr/lib/ccache/bin/:$PATH"
    export CCACHE_SLOPPINESS="file_macro,locale,time_macros"
    export CCACHE_NOHASHDIR="true"
    msg2 'ccache was found and will be used'
  fi

  # build!
  _runtime=$( time ( schedtool -B -n 1 -e ionice -n 1 make ${_force_all_threads} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 ) || _runtime=$( time ( make ${_force_all_threads} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 )
}

hackbase() {
  pkgdesc="The $pkgdesc kernel and modules"
  depends=('coreutils' 'kmod' 'initramfs')
  optdepends=('linux-docs: Kernel hackers manual - HTML documentation that comes with the Linux kernel.'
              'crda: to set the correct wireless channels of your country.'
              'linux-firmware: Firmware files for Linux'
              'modprobed-db: Keeps track of EVERY kernel module that has ever been probed. Useful for make localmodconfig.'
              'nvidia-tkg: NVIDIA drivers for all installed kernels - non-dkms version.'
              'nvidia-dkms-tkg: NVIDIA drivers for all installed kernels - dkms version.'
              'update-grub: Simple wrapper around grub-mkconfig.')
  provides=("linux=${pkgver}" "${pkgbase}" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
  replaces=(virtualbox-guest-modules-arch wireguard-arch)

  cd "${srcdir}/${_srcpath}"

  # get kernel version
  local _kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$_kernver"

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  msg2 "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 modules_install

  # remove build and source links
  rm "$modulesdir"/{source,build}

  # install cleanup pacman hook and script
  sed -e "s|cleanup|${pkgbase}-cleanup|g" "${srcdir}"/90-cleanup.hook |
    install -Dm644 /dev/stdin "${pkgdir}/usr/share/libalpm/hooks/90-${pkgbase}.hook"
  install -Dm755 "${srcdir}"/cleanup "${pkgdir}/usr/share/libalpm/scripts/${pkgbase}-cleanup"
}

hackheaders() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  provides=("linux-headers=${pkgver}" "${pkgbase}-headers=${pkgver}")

  cd "${srcdir}/${_srcpath}"
  local builddir="${pkgdir}/usr/lib/modules/$(<version)/build"

  msg2 "Installing build files..."
  install -Dt "$builddir" -m644 .config Makefile Module.symvers System.map \
    localversion.* version vmlinux
  install -Dt "$builddir/kernel" -m644 kernel/Makefile
  install -Dt "$builddir/arch/x86" -m644 arch/x86/Makefile
  cp -t "$builddir" -a scripts

  # add objtool for external module building and enabled VALIDATION_STACK option
  install -Dt "$builddir/tools/objtool" tools/objtool/objtool

  # add xfs and shmem for aufs building
  mkdir -p "$builddir"/{fs/xfs,mm}

  msg2 "Installing headers..."
  cp -t "$builddir" -a include
  cp -t "$builddir/arch/x86" -a arch/x86/include
  install -Dt "$builddir/arch/x86/kernel" -m644 arch/x86/kernel/asm-offsets.s

  install -Dt "$builddir/drivers/md" -m644 drivers/md/*.h
  install -Dt "$builddir/net/mac80211" -m644 net/mac80211/*.h

  # http://bugs.archlinux.org/task/13146
  install -Dt "$builddir/drivers/media/i2c" -m644 drivers/media/i2c/msp3400-driver.h

  # http://bugs.archlinux.org/task/20402
  install -Dt "$builddir/drivers/media/usb/dvb-usb" -m644 drivers/media/usb/dvb-usb/*.h
  install -Dt "$builddir/drivers/media/dvb-frontends" -m644 drivers/media/dvb-frontends/*.h
  install -Dt "$builddir/drivers/media/tuners" -m644 drivers/media/tuners/*.h

  msg2 "Installing KConfig files..."
  find . -name 'Kconfig*' -exec install -Dm644 {} "$builddir/{}" \;

  msg2 "Removing unneeded architectures..."
  local arch
  for arch in "$builddir"/arch/*/; do
    [[ $arch = */x86/ ]] && continue
    echo "Removing $(basename "$arch")"
    rm -r "$arch"
  done

  msg2 "Removing documentation..."
  rm -r "$builddir/Documentation"

  msg2 "Removing broken symlinks..."
  find -L "$builddir" -type l -printf 'Removing %P\n' -delete

  msg2 "Removing loose objects..."
  find "$builddir" -type f -name '*.o' -printf 'Removing %P\n' -delete

  msg2 "Stripping build tools..."
  local file
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
  done < <(find "$builddir" -type f -perm -u+x ! -name vmlinux -print0)

  msg2 "Adding symlink..."
  mkdir -p "$pkgdir/usr/src"
  ln -sr "$builddir" "$pkgdir/usr/src/$pkgbase"

  echo "Stripping vmlinux..."
  strip -v $STRIP_STATIC "$builddir/vmlinux"

  if [ $_NUKR = "true" ]; then
    rm -rf "$srcdir" # Nuke the entire src folder so it'll get regenerated clean on next build
  fi
}

source /dev/stdin <<EOF
package_${pkgbase}() {
hackbase
}

package_${pkgbase}-headers() {
hackheaders
}
EOF
