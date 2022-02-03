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

source "$_where"/customization.cfg # load default configuration from file
source "$_where"/linux-tkg-config/prepare

if [ -e "$_EXT_CONFIG_PATH" ]; then
  msg2 "External configuration file $_EXT_CONFIG_PATH will be used and will override customization.cfg values."
  source "$_EXT_CONFIG_PATH"
fi

# Make sure we're in a clean state
if [ ! -e "$_where"/BIG_UGLY_FROGMINER ]; then
  _tkg_initscript
fi

source "$_where"/BIG_UGLY_FROGMINER

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
pkgrel=243
pkgdesc='Linux-tkg'
arch=('x86_64') # no i686 in here
url="http://www.kernel.org/"
license=('GPL2')
makedepends=('bison' 'xmlto' 'docbook-xsl' 'kmod' 'inetutils' 'bc' 'libelf' 'pahole' 'patchutils' 'flex' 'python-sphinx' 'python-sphinx_rtd_theme' 'graphviz' 'imagemagick' 'git' 'cpio' 'perl' 'tar' 'xz' 'wget')
if [ "$_compiler_name" = "-llvm" ]; then
  makedepends+=( 'lld' 'clang' 'llvm')
fi
optdepends=('schedtool')
options=('!strip' 'docs')

case $_basever in
	54)
	#opt_ver="4.19-5.4"
	source=("$kernel_site"
        	"$patch_site"
        	#"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-4.19-5.4.patch"
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
        	0003-glitched-cfs-additions.patch
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
            'ea53726b5730f0b688ac1282e3e57b4453248ce70e438f38470db5555b4c2bc3'
            #'SKIP'
            'b0c4c60669f47ba4d3d1388368a5f9790aa697af42c917ed2ef177f111336d8b'
            '1f4a20d6eaaa0d969af93152a65191492400c6aa838fc1c290b0dd29bb6019d8'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            '31dc68e84aecfb7d069efb1305049122c65694676be8b955634abcf0675922a2'
            'd02bf5ca08fd610394b9d3a0c3b176d74af206f897dee826e5cbaec97bb4a4aa'
            '886ed1d648938d776a795d289af0c83207c1c70c00cd9d79560951d0bc951e25'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            '9420cf1a04740956008e535725ae38a2f759188841be3776447a4eb635fa5158'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            'bc69d6e5ee8172b0242c8fa72d13cfe2b8d2b6601468836908a7dfe8b78a3bbb'
            '815974c65f47301d2a5d1577bf95e8a4b54cad7d77f226e0065f83e763837c48'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            'eac7e5d6201528e64f4bdf5e286c842511e1afc52e1518dc8e7d11932bbe0a99'
            '29f7dc8930426b9cf86742ca80623b96b97c1d92a4436ba4e2adcde5200b4c29'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            '2d9260b80b43bbd605cf420d6bd53aa7262103dfd77196ba590ece5600b6dc0d'
            '3832f828a9f402b153fc9a6829c5a4eaf6091804bcda3a0423c8e1b57e26420d'
            'c98befca824f761260466410a1dd94d2b9be6f7211b5daefcfc0f3a102bbdc81'
            'aeb31404c26ee898d007b1f66cb9572c9884ad8eca14edc4587d68f6cba6de46')
	;;
	57)
	opt_ver="5.7"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/outdated_versions/enable_additional_cpu_optimizations_for_gcc_v10.1%2B_kernel_v5.7.patch"
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
            '357a0db541f7de924ed89c21f5a6f3de4889b134c5d05d5e32ccd234bd81eedf'
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
	opt_ver="5.8-5.14"
	source=("$kernel_site"
        	"$patch_site"
        	"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
            'f4754fbe2619ef321e49a7b560fad058b2459d17cff0b90e839cb475f46e8b63'
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
	opt_ver="5.8-5.14"
	source=("$kernel_site"
        	$patch_site
		"https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
            'ce2711b9d628e71af62706b830c2f259a43ad1e614871dd90bcb99d8709e1dab'
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
	opt_ver="5.8-5.14"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
        0003-glitched-cfs-additions.patch
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
        0007-v5.10-winesync.patch
        0008-5.10-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.10-r3.patch
        0012-linux-hardened.patch
        0012-misc-additions.patch
    )
    sha256sums=('dcdf99e43e98330d925016985bfbc7b83c66d367b714b2de0cbbfcbf83d8ca43'
            '0ad8e8fb4dd272aea40c4fa0508cc10cc4ccc9620e5ea186697b5926d74341e4'
            'SKIP'
            'f2d15531096e97239a67f7642d85666a2f27c5e053b38ff9a2aa704dfc388f8a'
            'eb1da1a028a1c967222b5bdac1db2b2c4d8285bafd714892f6fc821c10416341'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'acc50cd9f88b9f12dc4321fab7af66f6cc8299bb83ebcb4056f6189fca22ec9c'
            '7058e57fd68367b029adc77f2a82928f1433daaf02c8c279cb2d13556c8804d7'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '2bbbac963b6ca44ef3f8a71ec7c5cad7d66df860869a73059087ee236775970a'
            'e00096244e5cddaa5500d08b5f692fd3f25be9401dfa3b0fc624625ff2f5e198'
            '62496f9ca788996181ef145f96ad26291282fcc3fb95cdc04080dcf84365be33'
            '31b428c464905e44ed61cdcd1f42b4ec157ebe5a44cb5b608c4c99b466df66ba'
            'd29895468e2113538db457282e6d7a8ca6afec7c4bac5d98811f70fe1cdc333b'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            'f46ed0f026490b11b6a6cfb21e78cd253f0d7c308dc5a34e93971659a4eaa19e'
            'c2c0c6423d09278e300c481d891b8072ec5fd89e49e75f36a698b610aa819e65'
            '377d0eb1df251808b8280d1aec598b4a2986f7d167306cdec9048c337cdcf2e1'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'b9da77449157c36193d4dc8a43f4cebe7f13d9f6bbcdadbcbf1e61da1f5f887e'
            '105f51e904d80f63c1421203e093b612fc724edefd3e388b64f8d371c0b3a842'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24')
	;;
	511)
	opt_ver="5.8-5.14"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
        0004-5.11-ck1.patch
        0005-undead-glitched-ondemand-pds.patch
        0005-undead-glitched-pds.patch
        0005-v5.11_undead-pds099o.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.11-fsync.patch
        0007-v5.11-futex2_interface.patch
        0007-v5.11-winesync.patch
        0008-5.11-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.11-r3.patch
        0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('04f07b54f0d40adfab02ee6cbd2a942c96728d87c1ef9e120d0cb9ba3fe067b4'
            '07aac31956d3f483a91506524befd45962f3bbfda2f8d43cf90713caf872d9ba'
            'SKIP'
            'fc08ac33e3bc47ed0ee595a2e4b84bc45b02682b383db6acfe281792e88f6231'
            '837ad05b68d0443580f78f5eb316db46c6b67abfefa66c22b6cb94f4915a52ba'
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
            'c2c0c6423d09278e300c481d891b8072ec5fd89e49e75f36a698b610aa819e65'
            '6c831d7cdfe4897656b76c4ec60e0a18d6f3618f79c402ebc3bf4453a6616319'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '5cd64937e3a517f49f4311c47bd692eb8e117f09d655cd456e03366373ba8060'
            '9e7b1663f5247f15e883ce04e1dc2b18164aa19ebe47f75967be09659eff1101'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24'
            'b1c6599d0e1ac9b66898d652ed99dae3fb8676d840a43ffa920a78d96e0521be'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	512)
	opt_ver="5.8-5.14"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
        0003-glitched-cfs-additions.patch
        0004-glitched-ondemand-muqss.patch
        0004-glitched-muqss.patch
        0004-5.12-ck1.patch
        #0005-undead-glitched-ondemand-pds.patch
        #0005-undead-glitched-pds.patch
        #0005-v5.12_undead-pds099o.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.12-fsync.patch
        0007-v5.12-futex2_interface.patch
        0007-v5.12-winesync.patch
        0008-5.12-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.12-r1.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('7d0df6f2bf2384d68d0bd8e1fe3e071d64364dcdc6002e7b5c87c92d48fac366'
            'a41e4a4eb50c670a48f9c9bcc32ccb2195c02e3caa823a6aaed04537fdd8b73d'
            'SKIP'
            '0a7c40402715f8817c4f40173ca1fa8af84c56f7658be281e5424319000370b6'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'a447e697cb744283e3e89f300c8a8bda04a9c8108f03677fb48bf9675c992cbd'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            '3cdc90f272465c2edb6bac8a3c90f2e098ba8ca73d27e4c0cadf70b7e87641ea'
            'c8b0f2a1ef84b192c67b61c5a60426a640d5a83ac55a736929f0c4e6ec7b85f8'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'b302ba6c5bbe8ed19b20207505d513208fae1e678cf4d8e7ac0b154e5fe3f456'
            '540dda70cccc0cb23f0d0311f9947209cfe377070620e5fca69f66cc1efe817e'
            '9b324790ecf0240cbb314b8e02a7dcbfb14e3408267b702ad96f40a2ce77fdc2'
            'c6c5bcfac976c2304bdd13b80f8ad0329e5e53a6d9e9d130115204ea09fe2848'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '6325b3d6972725e41adbaf5e2db19a040dbf0856046cecc1c4d6786a064d04ff'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24'
            'b1c6599d0e1ac9b66898d652ed99dae3fb8676d840a43ffa920a78d96e0521be'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	513)
	opt_ver="5.8-5.14"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
        0003-glitched-cfs-additions.patch
        0004-glitched-ondemand-muqss.patch
        0004-glitched-muqss.patch
        0004-5.13-ck1.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.13-fsync.patch
        0007-v5.13-futex2_interface.patch
        0007-v5.13-futex_waitv.patch
        0007-v5.13-fsync1_via_futex_waitv.patch
        0007-v5.13-winesync.patch
        0008-5.13-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.13-r3.patch
        0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('3f6baa97f37518439f51df2e4f3d65a822ca5ff016aa8e60d2cc53b95a6c89d9'
            '6fadc31348a0c0bbce86b067811d1dadae307bbde5b712c688b3193d73f0fb71'
            'SKIP'
            '06ad99b810943f7ce4650fe656156f4b40d11fabd9b89e2b1beff06c46836efc'
            '49a34dfc8ee7663a8a20c614f086e16ec70e8822db27a91050fd6ffebf87a650'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'ef48eea194c1c101de0461572eaf311f232fee55c155c52904b20085a92db680'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'c605f638d74c61861ebdc36ebd4cb8b6475eae2f6273e1ccb2bbb3e10a2ec3fe'
            'de718ecea652a74e1d821459397d3dafaa3de1a7dba3df51ba9fc42b8645c3e2'
            '12d7c7457d4605ba00cb888383779e591a58e701643d763d8fe05dcdec3e9830'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            '89d837bfea3515504b1c99fc881ebdc4f15e2999558127a263e795fc69408a39'
            '9ec679871cba674cf876ba836cde969296ae5034bcc10e1ec39b372e6e07aab0'
            '0e3473c19e5513bee886f03cf2476f746d8b5b2fbc0841c9d60d609b16a97c14'
            'f5ed3062543074472172e30f3db4baa1e292b50e11c1c19e2511b71b28ac7e48'
            '9b324790ecf0240cbb314b8e02a7dcbfb14e3408267b702ad96f40a2ce77fdc2'
            'b0004bc559653fd8719b8adcfa1ead1075db3425d30d7d7adb8cbc6296386a8f'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            'ccf925b6326a8cf63d28c00a7645a0fa120608bfcf5dabb77a4522f249aa306d'
            'ab6471e61fad017ef1a5c3544a3c24029f81d7ad5bbdebbf98691ecfd051d4c4'
            '7fb1104c167edb79ec8fbdcde97940ed0f806aa978bdd14d0c665a1d76d25c24'
            'b1c6599d0e1ac9b66898d652ed99dae3fb8676d840a43ffa920a78d96e0521be'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	514)
	opt_ver="5.8-5.14"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.8-5.14.patch"
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
        0003-glitched-cfs-additions.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.14-fsync.patch
        0007-v5.14-futex2_interface.patch
        0007-v5.14-futex_waitv.patch
        0007-v5.14-fsync1_via_futex_waitv.patch
        0007-v5.14-winesync.patch
        #0008-5.14-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.14-r3.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('7e068b5e0d26a62b10e5320b25dce57588cbbc6f781c090442138c9c9c3271b2'
            '578be613998d8aa7e5460d6d5448799e422198d31e157c67eec2e5e58abb9c60'
            'SKIP'
            'f5d3635520c9eb9519629f6df0d9a58091ed4b1ea4ddb1acd5caf5822d91a060'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '2ed4f07f972f1a5c42fa7746f486a28c28a568404ca0caf7ae9416acbae5555a'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            'aa67e81a27d9062e463594acb91eca6dd13388f23cbe53ca56298f9dba61cc10'
            'efe5e21706fdf64559ead866c85a5d88c5c3f743d814410df3810ca61cc5b966'
            '5742277f41f22bf29fa9742562946b8a01377f8a22adb42ceed3607541c1d5b6'
            '5bd2e13d3c70abe4efefa1c4374a5d3801fece087f093ce6a8ca5b8466dc1f20'
            '9b324790ecf0240cbb314b8e02a7dcbfb14e3408267b702ad96f40a2ce77fdc2'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '1565038792869f1e99dc321b57d00dbfa14ab824a995f39c4d3effceab0b5415'
            '80a965ee61357c8f0a697eb71225976b7e352d4e54d9e576d3a1779d2a06714a'
            '1b656ad96004f27e9dc63d7f430b50d5c48510d6d4cd595a81c24b21adb70313'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	515)
	opt_ver="5.15%2B"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.15%2B.patch"
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
        0003-glitched-cfs-additions.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        0007-v5.15-fsync.patch
        0007-v5.15-futex_waitv.patch
        0007-v5.15-fsync1_via_futex_waitv.patch
        0007-v5.15-winesync.patch
        0008-5.15-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.15-r1.patch
        0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('57b2cf6991910e3b67a1b3490022e8a0674b6965c74c12da1e99d138d1991ee8'
            'b8624d726546c66490af074cbf9bb57a55f86cce52b0a8e7080f1ad1c9e06776'
            'SKIP'
            '6000b247aac5620ba08ec862353063f5f8806a33c4c8f55263843c8f47027e63'
            '5786bbcc3f655592958ba7011f9ce361d69211b0478c5b86bd3e600fee3ffd27'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            '2e2c5c546fb2aabfa90f31310355324f58c6783d520b45b8898577bb7d1a5277'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            '0b73ec751187d899a4c347b9287c7a76d06523abaeca985a76d0f7ae167d4b1f'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            '6c4f0099896f69e56ebd8c9eac266ac8ad993acecd50945e0e84ef6f95f9ddca'
            'c8f7c50d9b1418ba22b5ca735c47111a162be416109714d26a674162e5b2cb97'
            '63a2ddf7ca9d3922f4eac3ac66bc37ffb10ad8b18b3e596832d3faa66b93dfa6'
            '751c4b010d3cef24586fa35498d19060691ad4def35066a0048275b2c371781f'
            '68659b54bd0c0539c22869feea8017faf947af6883d75c00089f2bfd9f265f8e'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            '978b197efa56781a1d5651a3649c3d8b926d55748b4b9063788dfe1a861fc1bc'
            'd11edf802031e9335e4236ea1bb56d7fff9f6159dbc5f0afe407256b95d601fc'
            'c010206dc3278d2652afebaed9fac58e55e65f65deb0565687faa1dec577494b'
            '434e4707efc1bc3919597c87d44fa537f7563ae04236479bbf1adb5f410ab69d'
            '1b656ad96004f27e9dc63d7f430b50d5c48510d6d4cd595a81c24b21adb70313'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	516)
	opt_ver="5.15%2B"
    source=("$kernel_site"
        "$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.15%2B.patch"
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
        0003-glitched-cfs-additions.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        #0007-v5.16-fsync.patch
        0007-v5.16-fsync1_via_futex_waitv.patch
        0007-v5.16-winesync.patch
        #0008-5.14-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.16-r0.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('027d7e8988bb69ac12ee92406c3be1fe13f990b1ca2249e226225cd1573308bb'
            'f871ef945f5b316ac20f9801455afadd191af1ac99305cd43662959e45ddc533'
            'SKIP'
            'c1445d77355dc742f7690748d33c289ad7fd380c7aa66230ebf85d298c072729'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'fc6b5f3d03cacbb8ac547a8829f0c7544aaf7548f26298f8783d693a617b81d9'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            #'4503034f211de3013f8500106da753e5d1bcac14bc5576671cbe6f574805b3cd'
            '9df628fd530950e37d31da854cb314d536f33c83935adf5c47e71266a55f7004'
            'f91223f98f132602a4fa525917a1f27afe30bdb55a1ac863e739c536188417b3'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '5045d280e047a035d44df659fc389de5f97f5dde6aa179dab65658fcd90bfd71'
            #'decd4a55c0d47b1eb808733490cdfea1207a2022d46f06d04a3cc60fdcb3f32c'
            '1aa0a172e1e27fb8171053f3047dcf4a61bd2eda5ea18f02b2bb391741a69887'
            '1b656ad96004f27e9dc63d7f430b50d5c48510d6d4cd595a81c24b21adb70313'
            'b0319a7dff9c48b2f3e3d3597ee154bf92223149a633a8b7ce4026252db86da6')
	;;
	517)
	opt_ver="5.15%2B"
    source=("$kernel_site"
        #"$patch_site"
        "https://raw.githubusercontent.com/graysky2/kernel_compiler_patch/master/more-uarches-for-kernel-5.15%2B.patch"
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
        0003-glitched-cfs-additions.patch
        0005-glitched-pds.patch
        0006-add-acs-overrides_iommu.patch
        #0007-v5.16-fsync.patch
        0007-v5.17-fsync1_via_futex_waitv.patch
        0007-v5.17-winesync.patch
        #0008-5.14-bcachefs.patch
        0009-glitched-ondemand-bmq.patch
        0009-glitched-bmq.patch
        0009-prjc_v5.17-r0.patch
        #0012-linux-hardened.patch
        0012-misc-additions.patch
        # MM Dirty Soft for WRITE_WATCH support in Wine
        0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch
        0002-mm-Support-soft-dirty-flag-read-with-reset.patch
    )
    sha256sums=('8dd4284d331e49123917b5d0252750d072ff401ea64d8de45109211e0431ea93'
            #'9ff97f3a01ec8744863ff611315c44c1f5d1ff551769f7d8359c85561dee1b1d'
            'SKIP'
            '4f82607cedd7bad81b7a23a7a2dee093bc009cafd6f6548b9003d28404a4ab81'
            '1e15fc2ef3fa770217ecc63a220e5df2ddbcf3295eb4a021171e7edd4c6cc898'
            '66a03c246037451a77b4d448565b1d7e9368270c7d02872fbd0b5d024ed0a997'
            'f6383abef027fd9a430fd33415355e0df492cdc3c90e9938bf2d98f4f63b32e6'
            '35a7cde86fb94939c0f25a62b8c47f3de0dbd3c65f876f460b263181b3e92fc0'
            'fc6b5f3d03cacbb8ac547a8829f0c7544aaf7548f26298f8783d693a617b81d9'
            '5efd40c392ece498d2d43d5443e6537c2d9ef7cf9820d5ce80b6577fc5d1a4b2'
            'e5ea0bb25ee294c655ac3cc30e1eea497799826108fbfb4ef3258c676c1e8a12'
            'fca63d15ca4502aebd73e76d7499b243d2c03db71ff5ab0bf5cf268b2e576320'
            '19661ec0d39f9663452b34433214c755179894528bf73a42f6ba52ccf572832a'
            #'4503034f211de3013f8500106da753e5d1bcac14bc5576671cbe6f574805b3cd'
            '9df628fd530950e37d31da854cb314d536f33c83935adf5c47e71266a55f7004'
            'f91223f98f132602a4fa525917a1f27afe30bdb55a1ac863e739c536188417b3'
            '9fad4a40449e09522899955762c8928ae17f4cdaa16e01239fd12592e9d58177'
            'a557b342111849a5f920bbe1c129f3ff1fc1eff62c6bd6685e0972fc88e39911'
            '030421f809730752974116fcf5ed5f5c02a7fe2bb64c3ff1c8f7470ac65b4be2'
            #'decd4a55c0d47b1eb808733490cdfea1207a2022d46f06d04a3cc60fdcb3f32c'
            '1aa0a172e1e27fb8171053f3047dcf4a61bd2eda5ea18f02b2bb391741a69887'
            '1b656ad96004f27e9dc63d7f430b50d5c48510d6d4cd595a81c24b21adb70313'
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
  if [ -e "${srcdir}/${_srcpath}/include/uapi/linux/winesync.h" ]; then
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

  # add resolve_btfids on 5.16+
  if [ $_basever -ge 516 ]; then
    install -Dt "$builddir"/tools/bpf/resolve_btfids tools/bpf/resolve_btfids/resolve_btfids
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
