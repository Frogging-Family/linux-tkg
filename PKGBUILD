# Based on the file created for Arch Linux by:
# Tobias Powalowski <tpowa@archlinux.org>
# Thomas Baechler <thomas@archlinux.org>

# Contributor: Tk-Glitch <ti3nou at gmail dot com>
# Contributor: Hyper-KVM <hyperkvmx86 at gmail dot com>

plain '       .---.`               `.---.'
plain '    `/syhhhyso-           -osyhhhys/`'
plain '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
plain '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
plain '   :syNNdhNNhssssssssssssssshNNhdNNys:'
plain '    /ssyhhhysssssssssssssssssyhhhyss/'
plain '    .ossssssssssssssssssssssssssssso.'
plain '   :sssssssssssssssssssssssssssssssss:'
plain '  /sssssssssssssssssssssssssssssssssss/   Linux-tkg'
plain ' :sssssssssssssoosssssssoosssssssssssss:        kernels'
plain ' osssssssssssssoosssssssoossssssssssssso'
plain ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
plain ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
plain '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
plain '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
plain '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
plain '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
plain '             `.-:///////:-.`'

_where="$PWD" # track basedir as different Arch based distros are moving srcdir around
_ispkgbuild="true"
_distro="Arch"

declare -p -x > current_env

source "$_where"/customization.cfg # load default configuration from file

if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

source current_env

source "$_where"/linux-tkg-config/prepare

# Make sure we're in a clean state
if [ ! -e "$_where"/BIG_UGLY_FROGMINER ]; then
  _tkg_initscript
fi

source "$_where"/BIG_UGLY_FROGMINER

if [ -n "$_custom_pkgbase" ]; then
  pkgbase="${_custom_pkgbase}"
else
  pkgbase=linux"${_basever}"-tkg-"${_cpusched}"${_compiler_name}
fi
pkgname=("${pkgbase}" "${pkgbase}-headers")
pkgver="${_basekernel}"."${_sub}"
pkgrel=273
pkgdesc='Linux-tkg'
arch=('x86_64') # no i686 in here
url="https://www.kernel.org/"
license=('GPL2')
makedepends=('bison' 'xmlto' 'docbook-xsl' 'inetutils' 'bc' 'libelf' 'pahole' 'patchutils' 'flex' 'python-sphinx' 'python-sphinx_rtd_theme' 'graphviz' 'imagemagick' 'git' 'cpio' 'perl' 'tar' 'xz' 'wget')
if [ "$_compiler_name" = "-llvm" ]; then
  makedepends+=( 'lld' 'clang' 'llvm')
fi
optdepends=('schedtool')
options=('!strip' 'docs')

for f in "$_where"/linux-tkg-config/"$_basekernel"/* "$_where"/linux-tkg-patches/"$_basekernel"/*; do
  source+=( "$f" )
  sha256sums+=( "SKIP" )
done

export KBUILD_BUILD_HOST=archlinux
export KBUILD_BUILD_USER=$pkgbase
export KBUILD_BUILD_TIMESTAMP="$(date -Ru${SOURCE_DATE_EPOCH:+d @$SOURCE_DATE_EPOCH})"

prepare() {
  rm -rf $pkgdir # Nuke the entire pkg folder so it'll get regenerated clean on next build

  _define_kernel_abs_paths
  if [ -e "${srcdir}/customization.cfg" ]; then
    msg2 "Nuking remnant customization.cfg symlink" && rm -rf "${srcdir}/customization.cfg"
  fi
  ln -s "${_where}/customization.cfg" "${srcdir}"
  ln -s "${_kernel_work_folder_abs}" "${srcdir}"

  source "${_where}/current_env"

  _tkg_srcprep
}

build() {
  cd "$_kernel_work_folder_abs"

  # Use custom compiler paths if defined
  if [ "$_compiler_name" = "-llvm" ] && [ -n "${CUSTOM_LLVM_PATH}" ]; then
    PATH="${CUSTOM_LLVM_PATH}/bin:${CUSTOM_LLVM_PATH}/lib:${CUSTOM_LLVM_PATH}/include:${PATH}"
  elif [ -n "${CUSTOM_GCC_PATH}" ]; then
    PATH="${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}"
  fi

  if [ "$_force_all_threads" = "true" ]; then
    _force_all_threads="-j$((`nproc`+1))"
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

  # document the TkG variables, excluding "_", "_EXT_CONFIG_PATH", "_where", and "_path".
  declare -p | cut -d ' ' -f 3 | grep -P '^_(?!=|EXT_CONFIG_PATH|where|path)' > "${srcdir}/customization-full.cfg"

  # remove -O2 flag and place user optimization flag
  CFLAGS=${CFLAGS/-O2/}
  CFLAGS+=" ${_compileropt}"

  # build!
  _runtime=$( time ( schedtool -B -n 1 -e ionice -n 1 make ${_force_all_threads} ${llvm_opt} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 ) || _runtime=$( time ( make ${_force_all_threads} ${llvm_opt} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 )
}

hackbase() {
  pkgdesc="The $pkgdesc kernel and modules - https://github.com/Frogging-Family/linux-tkg"
  depends=('coreutils' 'kmod' 'initramfs')
  optdepends=('linux-docs: Kernel hackers manual - HTML documentation that comes with the Linux kernel.'
              'crda: to set the correct wireless channels of your country.'
              'linux-firmware: Firmware files for Linux'
              'modprobed-db: Keeps track of EVERY kernel module that has ever been probed. Useful for make localmodconfig.'
              'nvidia-tkg: NVIDIA drivers for all installed kernels - non-dkms version.'
              'nvidia-dkms-tkg: NVIDIA drivers for all installed kernels - dkms version.'
              'update-grub: Simple wrapper around grub-mkconfig.')
  if [ -e "${srcdir}/winesync.rules" ]; then
    provides=("linux=${pkgver}" "${pkgbase}" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE WINESYNC-MODULE winesync-header)
  else
    provides=("linux=${pkgver}" "${pkgbase}" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
  fi
  replaces=(virtualbox-guest-modules-arch wireguard-arch)

  _define_kernel_abs_paths
  cd "$_kernel_work_folder_abs"

  # get kernel version
  local _kernver="$(<version)"
  local modulesdir="$pkgdir/usr/lib/modules/$_kernver"

  msg2 "Installing boot image..."
  # systemd expects to find the kernel here to allow hibernation
  # https://github.com/systemd/systemd/commit/edda44605f06a41fb86b7ab8128dcf99161d2344
  install -Dm644 "$(make ${llvm_opt} -s image_name)" "$modulesdir/vmlinuz"

  # Used by mkinitcpio to name the kernel
  echo "$pkgbase" | install -Dm644 /dev/stdin "$modulesdir/pkgbase"

  msg2 "Installing modules..."
  make INSTALL_MOD_PATH="$pkgdir/usr" INSTALL_MOD_STRIP=1 \
    DEPMOD=/doesnt/exist modules_install  # Suppress depmod

  # remove build and source links
  rm "$modulesdir"/{source,build}

  # install cleanup pacman hook and script
  sed -e "s|cleanup|${pkgbase}-cleanup|g" "${srcdir}"/90-cleanup.hook |
    install -Dm644 /dev/stdin "${pkgdir}/usr/share/libalpm/hooks/90-${pkgbase}.hook"
  install -Dm755 "${srcdir}"/cleanup "${pkgdir}/usr/share/libalpm/scripts/${pkgbase}-cleanup"

  # install customization file, for reference
  install -Dm644 "${srcdir}"/customization-full.cfg "${pkgdir}/usr/share/doc/${pkgbase}/customization.cfg"

  # workaround for missing header with winesync
  if [ -e "${_kernel_work_folder_abs}/include/uapi/linux/winesync.h" ]; then
    msg2 "Workaround missing winesync header"
    install -Dm644 "${_kernel_work_folder_abs}"/include/uapi/linux/winesync.h "${pkgdir}/usr/include/linux/winesync.h"
  fi

  # load winesync module at boot
  if [ -e "${srcdir}/winesync.conf" ]; then
    msg2 "Set the winesync module to be loaded at boot through /etc/modules-load.d"
    install -Dm644 "${srcdir}"/winesync.conf "${pkgdir}/etc/modules-load.d/winesync.conf"
  fi

  # install udev rule for winesync
  if [ -e "${srcdir}/winesync.rules" ]; then
    msg2 "Installing udev rule for winesync"
    install -Dm644 "${srcdir}"/winesync.rules "${pkgdir}/etc/udev/rules.d/winesync.rules"
  fi
}

hackheaders() {
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel - https://github.com/Frogging-Family/linux-tkg"
  provides=("linux-headers=${pkgver}" "${pkgbase}-headers=${pkgver}")
  case $_basever in
    54|57|58|59|510)
    ;;
    *)
      depends=('pahole')
    ;;
  esac

  _define_kernel_abs_paths
  cd "$_kernel_work_folder_abs"

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

  # add resolve_btfids on 5.16+
  if [[ $_basever = 6* ]] || [ $_basever -ge 516 ]; then
    install -Dt "$builddir"/tools/bpf/resolve_btfids tools/bpf/resolve_btfids/resolve_btfids || ( warning "$builddir/tools/bpf/resolve_btfids was not found. This is undesirable and might break dkms modules !!! Please review your config changes and consider using the provided defconfig and tweaks without further modification." && read -rp "Press enter to continue anyway" )
  fi

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
    case "$(file -Sib "$file")" in
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

  if [ "$_STRIP" = "true" ]; then
    echo "Stripping vmlinux..."
    strip -v $STRIP_STATIC "$builddir/vmlinux"
  fi

  if [ "$_NUKR" = "true" ]; then
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
