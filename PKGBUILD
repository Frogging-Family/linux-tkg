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

if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

_tkg_initscript

if [[ "$_sub" = rc* ]]; then
  _srcpath="linux-${_basekernel}-${_sub}"
  kernel_site="https://git.kernel.org/torvalds/t/linux-${_basekernel}-${_sub}.tar.gz"
else
  _srcpath="linux-${_basekernel}"
  kernel_site="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${_basekernel}.tar.xz"
  patch_site="https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-${_basekernel}.${_sub}.xz"
fi

if [ -n "$_custom_pkgbase" ]; then
  pkgbase="${_custom_pkgbase}"
else
  pkgbase=linux"${_basever}"-tkg-"${_cpusched}"${_compiler_name}
fi
pkgname=("${pkgbase}" "${pkgbase}-headers")
pkgver="${_basekernel}"."${_sub}"
pkgrel=140
pkgdesc='Linux-tkg'
arch=('x86_64') # no i686 in here
url="http://www.kernel.org/"
license=('GPL2')
makedepends=('bison' 'xmlto' 'docbook-xsl' 'kmod' 'inetutils' 'bc' 'libelf' 'pahole' 'patchutils' 'flex' 'python-sphinx' 'python-sphinx_rtd_theme' 'graphviz' 'imagemagick' 'git' 'cpio' 'perl' 'tar' 'xz')
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
        	"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-4.19-v5.4.patch"
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
        	0012-linux-hardened.patch
	)
	sha256sums=('bf338980b1670bca287f9994b7441c2361907635879169c64ae78364efc5f491'
            'e3d7c23c02e3a888beb59fc8087c52d8812cd1554ccd37fd5c948d0e9ed117b7'
            'SKIP'
            'be2066dd6133357007e8c7da9d5de3194b13409ebbfba8821db1849588fced1e'
            '1f4a20d6eaaa0d969af93152a65191492400c6aa838fc1c290b0dd29bb6019d8'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            '31dc68e84aecfb7d069efb1305049122c65694676be8b955634abcf0675922a2'
            'd02bf5ca08fd610394b9d3a0c3b176d74af206f897dee826e5cbaec97bb4a4aa'
            '3ef74dd80dc8c4323803cbf868178cf01d8ed69f09fe2f537ff91124cbd6e611'
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
            'aeb31404c26ee898d007b1f66cb9572c9884ad8eca14edc4587d68f6cba6de46')
	;;
	57)
	opt_ver="5.7"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/outdated_versions/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.7.patch"
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
        	0012-linux-hardened.patch
	)
	sha256sums=('de8163bb62f822d84f7a3983574ec460060bf013a78ff79cd7c979ff1ec1d7e0'
            '66a0173a13cd58015f5bf1b14f67bfa15dc1db5d8e7225fcd95ac2e9a5341653'
            'SKIP'
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
            '6821f92bd2bde3a3938d17b070d70f18a2f33cae81647567b5a4d94c9cd75f3d')
	;;
	58)
	opt_ver="5.8%2B"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-5.8%2B.patch"
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
        	#0012-linux-hardened.patch
	)
	sha256sums=('e7f75186aa0642114af8f19d99559937300ca27acaf7451b36d4f9b0f85cf1f5'
            '5b558a40c2fdad2c497fe0b1a64679313fd5a7ccbaecef8803d49b3baaccbacd'
            'SKIP'
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
            'e73c3a8a040a35eb48d1e0ce4f66dd6e6f69fd10ee5b1acf3a0334cbf7ffb0c4'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            '965a517a283f265a012545fbb5cc9e516efc9f6166d2aa1baf7293a32a1086b7'
            'f5dbff4833a2e3ca94c202e5197894d5f1006c689ff149355353e77d2e17c943')
	;;
	59)
	opt_ver="5.8%2B"
	source=("$kernel_site"
        	$patch_site
		"https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-5.8%2B.patch"
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
		0005-undead-glitched-ondemand-pds.patch
		0005-undead-glitched-pds.patch
		0005-v5.9_undead-pds099o.patch
		0005-glitched-pds.patch
        	0006-add-acs-overrides_iommu.patch
		0007-v5.9-fsync.patch
        	0008-5.9-bcachefs.patch
		0009-glitched-ondemand-bmq.patch
		0009-glitched-bmq.patch
		0009-prjc_v5.9-r3.patch
	        #0012-linux-hardened.patch
	)
	sha256sums=('3239a4ee1250bf2048be988cc8cb46c487b2c8a0de5b1b032d38394d5c6b1a06'
            '46c520da2db82d8f9a15c2117d3a50e0faaaf98f05bd4ea1f3105e2724f207d6'
            'SKIP'
            '958333f18de79c19ccf9eccb4e16e2a217a0619a1d96c2c65ccba23628815bab'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '902885088ed0748e40372e04a8ec11adf5acf3d935abffc6737dd9e6ec13bb93'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            '45a9ab99215ab3313be6e66e073d29154aac55bc58975a4df2dad116c918d27c'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '31b428c464905e44ed61cdcd1f42b4ec157ebe5a44cb5b608c4c99b466df66ba'
            'f9f5f0a3a1d6c5233b9d7a4afe8ed99be97c4ff00a80bde4017d117c7d5f98ed'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '14a261f1940a2b21b6b14df7391fc2c6274694bcfabfac3d0e985a67285dbfe7'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '0d5fe3a9050536fe431564b221badb85af7ff57b330e3978ae90d21989fcad2d')
	;;
	510)
	opt_ver="5.8%2B"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-5.8%2B.patch"
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
        0004-5.10-ck1.patch
        0005-undead-glitched-ondemand-pds.patch
        0005-undead-glitched-pds.patch
        0005-v5.10_undead-pds099o.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.10-fsync.patch
        0007-v5.10-futex2_interface.patch
        0008-5.10-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.10-r2.patch
        0012-linux-hardened.patch
        0012-misc-additions.patch
    )
    sha256sums=('dcdf99e43e98330d925016985bfbc7b83c66d367b714b2de0cbbfcbf83d8ca43'
            '5a3cb361a621aa753790faee038732fffaa0406a5771f545df68a5afa2164a36'
            'SKIP'
            '458d1ca195f3fee5501683a4b61ef0ed0cfa7e5219eccab3390fb40c0289898a'
            'eb1da1a028a1c967222b5bdac1db2b2c4d8285bafd714892f6fc821c10416341'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '1ac97da07e72ec7e2b0923d32daacacfaa632a44c714d6942d9f143fe239e1b5'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            'e00096244e5cddaa5500d08b5f692fd3f25be9401dfa3b0fc624625ff2f5e198'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '31b428c464905e44ed61cdcd1f42b4ec157ebe5a44cb5b608c4c99b466df66ba'
            '06e93b57b7a0b96aefc2c0ec12c3be28c6e8dc8506fa8a22c5a2313814a3c7f3'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '47c05c6e7e1280dca137ed2139dac7da0d026a27d5590fd386748d1827288a61'
            'c5dd103953b8830640538ba30ff511028bd93310f95e4f5587a6ed5e6414a60d'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'e308292fc42840a2366280ea7cf26314e92b931bb11f04ad4830276fc0326ee1'
            '105f51e904d80f63c1421203e093b612fc724edefd3e388b64f8d371c0b3a842'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24')
	;;
	511)
	opt_ver="5.8%2B"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-5.8%2B.patch"
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
        0004-5.11-ck1.patch
        0005-undead-glitched-ondemand-pds.patch
        0005-undead-glitched-pds.patch
        0005-v5.11_undead-pds099o.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.11-fsync.patch
        0007-v5.11-futex2_interface.patch
        0007-v5.11-winesync.patch
        #0008-5.11-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.11-r2.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('04f07b54f0d40adfab02ee6cbd2a942c96728d87c1ef9e120d0cb9ba3fe067b4'
            'dffcabb33733c58344243d722f77f0b38616796b7ecb287892ccb975c91de077'
            'SKIP'
            'd8d5d11c80424985642b0eea6ace3256b5a1e5e69d637104523460a5ebdda202'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '1ac97da07e72ec7e2b0923d32daacacfaa632a44c714d6942d9f143fe239e1b5'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            '2f7e24e70ed1f5561155a1b5e5aab9927aea317db0500e8cf83cd059807f9c7e'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '31b428c464905e44ed61cdcd1f42b4ec157ebe5a44cb5b608c4c99b466df66ba'
            '4169fffe69eb5216831e545cb7439fa8e3fc09066757d7d4c496fe024fc373ee'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '073e7b8ab48aa9abdb5cedb5c729a2f624275ebdbe1769476231c9e712145496'
            '1d29c190cb2521e5f86bb40f3d4c55f993463544f973bc2650836f85a3c58f98'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'e394d4b7721f55837a8364c8311cb06cb5a59484de8aa8731e38d1aff2b7014e'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24'
            'b1c6599d0e1ac9b66898d652ed99dae3fb8676d840a43ffa920a78d96e0521be'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	512)
	opt_ver="5.8%2B"
    source=("$kernel_site"
        #"$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/master/more-uarches-for-gcc-v10-and-kernel-5.8%2B.patch"
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
        #0004-5.12-ck1.patch
        #0005-undead-glitched-ondemand-pds.patch
        #0005-undead-glitched-pds.patch
        #0005-v5.12_undead-pds099o.patch
        #0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.12-fsync.patch
        0007-v5.12-futex2_interface.patch
        #0008-5.12-bcachefs.patch
        #0009-glitched-ondemand-bmq.patch
        #0009-glitched-bmq.patch
        #0009-prjc_v5.12-r0.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('cb251b82131e29c575db3820c9ad62c044d07bcf8bf0bf38482ba55d52dc95b7'
            'SKIP'
            'a48dc999e51763db63a1e52a8a2cc23b4116fbf03a731b999878da8578598115'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '1ac97da07e72ec7e2b0923d32daacacfaa632a44c714d6942d9f143fe239e1b5'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            'fc0a3274e3285278e925f4b3bfe803e5e610344bebe5bba063ba202dbaff49c8'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24'
            'b1c6599d0e1ac9b66898d652ed99dae3fb8676d840a43ffa920a78d96e0521be'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
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

  # document the TkG variables, excluding "_", "_EXT_CONFIG_PATH", "_where", and "_path".
  declare -p | cut -d ' ' -f 3 | grep -P '^_(?!=|EXT_CONFIG_PATH|where|path)' > "${srcdir}/customization-full.cfg"

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
  if [ -e "${srcdir}/winesync.rules" ]; then
    provides=("linux=${pkgver}" "${pkgbase}" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE WINESYNC-MODULE winesync-header)
  else
    provides=("linux=${pkgver}" "${pkgbase}" VIRTUALBOX-GUEST-MODULES WIREGUARD-MODULE)
  fi
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

  # workaround for missing header with winesync
  if [ -e ""${srcdir}/${_srcpath}"/include/uapi/linux/winesync.h" ]; then
    msg2 "Workaround missing winesync header"
    install -Dm644 "${srcdir}/${_srcpath}"/include/uapi/linux/winesync.h "${pkgdir}/usr/include/linux/winesync.h"
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
  pkgdesc="Headers and scripts for building modules for the $pkgdesc kernel"
  provides=("linux-headers=${pkgver}" "${pkgbase}-headers=${pkgver}")
  case $_basever in
    54|57|58|59|510)
    ;;
    *)
      depends=('pahole')
    ;;
  esac

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
