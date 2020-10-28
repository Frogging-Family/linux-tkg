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

source "$_where"/customization.cfg # load default configuration from file
source "$_where"/linux-tkg-config/prepare

_tkg_initscript

if [[ "$_sub" = rc* ]]; then
  _srcpath="linux-${_basekernel}-${_sub}"
  kernel_site="https://git.kernel.org/torvalds/t/linux-${_basekernel}-${_sub}.tar.gz"
else
  _srcpath="linux-${_basekernel}"
  kernel_site="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${_basekernel}.tar.xz"
  patch_site="https://www.kernel.org/pub/linux/kernel/v5.x/patch-${_basekernel}.${_sub}.xz"
fi

if [ -n "$_custom_pkgbase" ]; then
  pkgbase="${_custom_pkgbase}"
else
  pkgbase=linux"${_basever}"-tkg-"${_cpusched}"${_compiler_name}
fi
pkgname=("${pkgbase}" "${pkgbase}-headers")
pkgver="${_basekernel}"."${_sub}"
pkgrel=6
pkgdesc='Linux-tkg'
arch=('x86_64') # no i686 in here
url="http://www.kernel.org/"
license=('GPL2')
makedepends=('xmlto' 'docbook-xsl' 'kmod' 'inetutils' 'bc' 'libelf' 'pahole' 'patchutils' 'flex' 'python-sphinx' 'python-sphinx_rtd_theme' 'graphviz' 'imagemagick' 'git')
if [ "$_compiler_name" = "-llvm" ]; then
  makedepends+=( 'lld' 'clang' 'llvm')
fi
optdepends=('schedtool')
options=('!strip' 'docs')

case $_basever in
	54)
	opt_ver="4.19-v5.4"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v4.19-v5.4.patch"
        	'config.x86_64' # stock Arch config
        	'config_hardened.x86_64' # hardened Arch config
        	90-cleanup.hook
        	cleanup
        	# ARCH Patches
        	0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch
        	# TkG
        	0002-clear-patches.patch
        	0003-glitched-base.patch
        	0003-glitched-cfs.patch
        	0004-glitched-ondemand-muqss.patch
        	0004-glitched-muqss.patch
        	0004-5.4-ck1.patch
        	0005-glitched-ondemand-pds.patch
        	0005-glitched-pds.patch
        	0005-v5.4_undead-pds099o.patch
        	0006-add-acs-overrides_iommu.patch
        	0007-v5.4-fsync.patch
        	#0008-5.4-bcachefs.patch
        	0009-glitched-bmq.patch
        	0009-bmq_v5.4-r2.patch
        	0011-ZFS-fix.patch
        	0012-linux-hardened.patch
	)
	sha256sums=('bf338980b1670bca287f9994b7441c2361907635879169c64ae78364efc5f491'
            'bce941bcb6c8148ac19cd2fa4f1e19c6c75f699a3bcdfd452df7484cff2a2353'
            '27b7fc535ade94b636c3ec4e809e141831e9465a0ef55215a9852b87048629e2'
            '55dd5117c1da17c9ec38d7bc995958958bcc8b7ebcfd81de1d4c7650b85537ab'
            '1f4a20d6eaaa0d969af93152a65191492400c6aa838fc1c290b0dd29bb6019d8'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            '31dc68e84aecfb7d069efb1305049122c65694676be8b955634abcf0675922a2'
            'd02bf5ca08fd610394b9d3a0c3b176d74af206f897dee826e5cbaec97bb4a4aa'
            '156a2c75fd228920e3c3da5e04a110afa403951bdfbb85772c2fd4b82fd24d61'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            'bc69d6e5ee8172b0242c8fa72d13cfe2b8d2b6601468836908a7dfe8b78a3bbb'
            '815974c65f47301d2a5d1577bf95e8a4b54cad7d77f226e0065f83e763837c48'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            'eac7e5d6201528e64f4bdf5e286c842511e1afc52e1518dc8e7d11932bbe0a99'
            'db03fbd179ec78941eefe1c0edde4c19071bc603511d0b5c06c04e412994b62e'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            '2d9260b80b43bbd605cf420d6bd53aa7262103dfd77196ba590ece5600b6dc0d'
            '3832f828a9f402b153fc9a6829c5a4eaf6091804bcda3a0423c8e1b57e26420d'
            '6a6a736cf1b3513d108bfd36f60baf50bb36b33aec21ab0d0ffad13602b7ff75'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            'aeb31404c26ee898d007b1f66cb9572c9884ad8eca14edc4587d68f6cba6de46')
	;;
	57)
	opt_ver="5.7%2B"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.7%2B.patch"
        	'config.x86_64' # stock Arch config
        	'config_hardened.x86_64' # hardened Arch config
        	90-cleanup.hook
        	cleanup
        	# ARCH Patches
        	0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch
        	# TkG
        	0002-clear-patches.patch
        	0003-glitched-base.patch
        	0003-glitched-cfs.patch
        	0004-glitched-ondemand-muqss.patch
        	0004-glitched-muqss.patch
        	0004-5.7-ck1.patch
        	0005-glitched-ondemand-pds.patch
        	0005-glitched-pds.patch
        	0005-v5.7_undead-pds099o.patch
        	0006-add-acs-overrides_iommu.patch
        	0007-v5.7-fsync.patch
        	0008-5.7-bcachefs.patch
        	0009-glitched-ondemand-bmq.patch
        	0009-glitched-bmq.patch
        	0009-prjc_v5.7-r3.patch
        	0011-ZFS-fix.patch
        	0012-linux-hardened.patch
        	0012-misc-additions.patch
	)
	sha256sums=('de8163bb62f822d84f7a3983574ec460060bf013a78ff79cd7c979ff1ec1d7e0'
            '66a0173a13cd58015f5bf1b14f67bfa15dc1db5d8e7225fcd95ac2e9a5341653'
            '1f56a2466bd9b4477925682d8f944fabb38727140e246733214fe50aa326fc47'
            '6313ccad7f8e4d8ce09dd5bdb51b8dfa124d0034d7097ba47008380a14a84f09'
            '15ce09447b7e9b28425c1df5961c955378f2829e4115037337eef347b1db3d9d'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            '31dc68e84aecfb7d069efb1305049122c65694676be8b955634abcf0675922a2'
            'd02bf5ca08fd610394b9d3a0c3b176d74af206f897dee826e5cbaec97bb4a4aa'
            'bbf332201423888257c9687bee06916a5dbbac2194f9df5b4126100c40e48d16'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            'bc69d6e5ee8172b0242c8fa72d13cfe2b8d2b6601468836908a7dfe8b78a3bbb'
            '8d8aec86e34dbec6cc3a47f2cd55dc9212e95d36b6cd34d6e637c66731e7d838'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '7fd8e776209dac98627453fda754bdf9aff4a09f27cb0b3766d7983612eb3c74'
            '55be5e4c6254da0a9d34bbfac807a70d8b58b3f7b2ec852026195c4db5e263e2'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'cd225e86d72eaf6c31ef3d7b20df397f4cc44ddd04389850691292cdf292b204'
            'd2214504c43f9d297a8ef68dffc198143bfebf85614b71637a71978d7a86bd78'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            '965a517a283f265a012545fbb5cc9e516efc9f6166d2aa1baf7293a32a1086b7'
            'b2a2ae866fc3f1093f67e69ba59738827e336b8f800fb0487599127f7f3ef881'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            '6821f92bd2bde3a3938d17b070d70f18a2f33cae81647567b5a4d94c9cd75f3d'
            'bdc60c83cd5fbf9912f9201d6e4fe3c84fe5f634e6823bd8e78264ad606b3a9e')
	;;
	58)
	opt_ver="5.8%2B"
	source=("$kernel_site"
        	"$patch_site"
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
        	0005-undead-glitched-ondemand-pds.patch
        	0005-undead-glitched-pds.patch
        	0005-v5.8_undead-pds099o.patch
        	0005-glitched-pds.patch
        	0006-add-acs-overrides_iommu.patch
        	0007-v5.8-fsync.patch
        	0008-5.8-bcachefs.patch
        	0009-glitched-ondemand-bmq.patch
        	0009-glitched-bmq.patch
        	0009-prjc_v5.8-r3.patch
        	0011-ZFS-fix.patch
        	#0012-linux-hardened.patch
        	0012-misc-additions.patch
	)
	sha256sums=('e7f75186aa0642114af8f19d99559937300ca27acaf7451b36d4f9b0f85cf1f5'
            '2ea49982bd10e4c880d49051535bd820e276dd3235c3c913b255aaaadc707e1d'
            '5ab29eb64e57df83b395a29a6a4f89030d142feffbfbf73b3afc6d97a2a7fd12'
            'ac66686b0e1ed057ea5f099cd00366decc00f999aa1cb19ba8d3ccf9f92d60e2'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'b9ebe0ae69bc2b2091d6bfcf6c7875a87ea7969fcfa4e306c48d47a60f9ef4d6'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '7fd8e776209dac98627453fda754bdf9aff4a09f27cb0b3766d7983612eb3c74'
            '31b172eb6a0c635a8d64cc1c2e8181d9f928ee991bd44f6e556d1713b815f8d9'
            '87bca363416655bc865fcb2cc0d1532cb010a61d9b9f625e3c15cd12eeee3a59'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'cd225e86d72eaf6c31ef3d7b20df397f4cc44ddd04389850691292cdf292b204'
            '86414a20225deec084e0e48b35552b3a4eef67f76755b32a10febb7b6308dcb7'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            '965a517a283f265a012545fbb5cc9e516efc9f6166d2aa1baf7293a32a1086b7'
            'f5dbff4833a2e3ca94c202e5197894d5f1006c689ff149355353e77d2e17c943'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            '98311deeb474b39e821cd1e64198793d5c4d797155b3b8bbcb1938b7f11e8d74')
	;;
	59)
	opt_ver="5.8%2B"
	source=("$kernel_site"
        	$patch_site
		"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.8%2B.patch"
        	"config.x86_64" # stock Arch config
        	#$hardened_config_file # hardened Arch config
        	90-cleanup.hook
        	cleanup
        	# ARCH Patches
		0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch
        	# TkG
        	0002-clear-patches.patch
		0003-glitched-base.patch
        	0003-glitched-cfs.patch
	        0004-glitched-ondemand-muqss.patch
        	0004-glitched-muqss.patch
	        0004-5.9-ck1.patch
		#0005-undead-glitched-ondemand-pds.patch
		#0005-undead-glitched-pds.patch
		#0005-v5.8_undead-pds099o.patch
		0005-glitched-pds.patch
        	0006-add-acs-overrides_iommu.patch
		0007-v5.9-fsync.patch
        	0008-5.9-bcachefs.patch
		0009-glitched-ondemand-bmq.patch
		0009-glitched-bmq.patch
		0009-prjc_v5.9-r1.patch
        	0011-ZFS-fix.patch
	        #0012-linux-hardened.patch
		0012-misc-additions.patch
	)
	sha256sums=('3239a4ee1250bf2048be988cc8cb46c487b2c8a0de5b1b032d38394d5c6b1a06'
            '7edb7b9d06b02f9b88d868c74ab618baf899c94edb19a73291f640dbea55c312'
            '5ab29eb64e57df83b395a29a6a4f89030d142feffbfbf73b3afc6d97a2a7fd12'
            '36439a90c9d2f860298d90e141f3bf9d897dd8ece9e21cd46508f4ed7b2151bb'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '902885088ed0748e40372e04a8ec11adf5acf3d935abffc6737dd9e6ec13bb93'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            '45a9ab99215ab3313be6e66e073d29154aac55bc58975a4df2dad116c918d27c'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '78373044a416c512d74a1fb0227cbc2e4a47023791e21e2536626fce9401fbf7'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'a5149d7220457d30e03e6999f35a050bce46acafc6230bfe6b4d4994c523516d'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            '433b919e6a0be26784fb4304c43b1811a28f12ad3de9e26c0af827f64c0c316e')
	;;
	510)
	opt_ver="5.8%2B"
    source=("$kernel_site"
        #"$patch_site"
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
        0004-glitched-ondemand-muqss.patch
        0004-glitched-muqss.patch
        0004-5.10-ck1.patch
        #0005-undead-glitched-ondemand-pds.patch
        #0005-undead-glitched-pds.patch
        #0005-v5.10_undead-pds099o.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.10-fsync.patch
        #0008-5.10-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.10-r0.patch
        0011-ZFS-fix.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
    )
    sha256sums=('483d8b3945963ea375026c4dde019da36f5d2116241036b09493e63e92e39ee8'
            '5ab29eb64e57df83b395a29a6a4f89030d142feffbfbf73b3afc6d97a2a7fd12'
            '834247434877e4e76201ada7df35ebd4622116737e9650e0772f22d03083b426'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '1ac97da07e72ec7e2b0923d32daacacfaa632a44c714d6942d9f143fe239e1b5'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            '4231bd331289f5678b49d084698f0a80a3ae602eccb41d89e4f85ff4465eb971'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'a5149d7220457d30e03e6999f35a050bce46acafc6230bfe6b4d4994c523516d'
            '49262ce4a8089fa70275aad742fc914baa28d9c384f710c9a62f64796d13e104'
            '433b919e6a0be26784fb4304c43b1811a28f12ad3de9e26c0af827f64c0c316e')
	;;
esac

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
  if [ "$_compiler_name" = "-llvm" ] && [ -n "${CUSTOM_LLVM_PATH}" ]; then
    PATH=${CUSTOM_LLVM_PATH}/bin:${CUSTOM_LLVM_PATH}/lib:${CUSTOM_LLVM_PATH}/include:${PATH}
  elif [ -n "${CUSTOM_GCC_PATH}" ]; then
    PATH=${CUSTOM_GCC_PATH}/bin:${CUSTOM_GCC_PATH}/lib:${CUSTOM_GCC_PATH}/include:${PATH}
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

  # document the TkG variables, excluding "_", "_EXT_CONFIG_PATH", and "_where".
  declare -p | cut -d ' ' -f 3 | grep -P '^_(?!=|EXT_CONFIG_PATH|where)' > "${srcdir}/customization-full.cfg"

  # remove -O2 flag and place user optimization flag
  CFLAGS=${CFLAGS/-O2/}
  CFLAGS+=" ${_compileropt}"

  # build!
  _runtime=$( time ( schedtool -B -n 1 -e ionice -n 1 make ${_force_all_threads} ${llvm_opt} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 ) || _runtime=$( time ( make ${_force_all_threads} ${llvm_opt} LOCALVERSION= bzImage modules 2>&1 ) 3>&1 1>&2 2>&3 )
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
  install -Dm644 "$(make ${llvm_opt} -s image_name)" "$modulesdir/vmlinuz"

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

  # install customization file, for reference
  install -Dm644 "${srcdir}"/customization-full.cfg "${pkgdir}/usr/share/doc/${pkgbase}/customization.cfg"
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
