# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="16"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
PRJC_R=1

inherit kernel-2 optfeature
detect_version
detect_arch

# major kernel version, e.g. 5.14
SHPV="${KV_MAJOR}.${KV_MINOR}"

COMMUNITY_SHPY="${KV_MAJOR}${KV_MINOR}"

KEYWORDS="~amd64"

IUSE="bmq pds bcachefs cjktty cfs"
DESCRIPTION="the Linux Kernel with a selection of patches aiming for better desktop/gaming experience and Gentoo's genpatches"
HOMEPAGE="https://github.rc1844.workers.dev/Frogging-Family/linux-tkg"
REQUIRED_USE="^^ ( bmq pds cfs )"

SRC_URI="${GENPATCHES_URI} ${KERNEL_URI} ${ARCH_URI}
		https://github.rc1844.workers.dev/graysky2/kernel_compiler_patch/raw/master/more-uarches-for-kernel-${SHPV}%2B.patch -> more-uarches-for-kernel-${SHPV}%2B-${PV}.patch
		https://github.rc1844.workers.dev/HougeLangley/customkernel/releases/download/v${SHPV}-others/v1-cjktty-${SHPV}.patch
		https://github.rc1844.workers.dev/sirlucjan/kernel-patches/raw/master/${SHPV}/bbr2-patches/0001-bbr2-${SHPV}-introduce-BBRv2.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by.patch -> 0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range.patch -> 0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0002-clear-patches.patch -> 0002-clear-patches-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0002-mm-Support-soft-dirty-flag-read-with-reset.patch -> 0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0003-glitched-base.patch -> 0003-glitched-base-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0005-glitched-pds.patch -> 0005-glitched-pds-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0006-add-acs-overrides_iommu.patch -> 0006-add-acs-overrides_iommu-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0007-v${SHPV}-fsync.patch -> 0007-v${SHPV}-fsync-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0007-v${SHPV}-winesync.patch -> 0007-v${SHPV}-winesync-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0008-${SHPV}-bcachefs.patch -> 0008-${SHPV}-bcachefs-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0009-glitched-bmq.patch -> 0009-glitched-bmq-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0009-glitched-ondemand-bmq.patch -> 0009-glitched-ondemand-bmq-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/raw/master/linux-tkg-patches/${SHPV}/0009-prjc_v${SHPV}-r${PRJC_R}.patch -> 0009-prjc_v${SHPV}-r${PRJC_R}-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/blob/master/linux-tkg-patches/${SHPV}/0003-glitched-base.patch -> 0003-glitched-base-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/blob/master/linux-tkg-patches/${SHPV}/0003-glitched-cfs.patch -> 0003-glitched-cfs-${PV}.patch
		https://github.rc1844.workers.dev/Frogging-Family/linux-tkg/blob/master/linux-tkg-patches/${SHPV}/0003-glitched-cfs-additions.patch -> 0003-glitched-cfs-additions-${PV}.patch
"


pkg_setup() {
	kernel-2_pkg_setup
}

src_prepare() {
	# kernel-2_src_prepare doesn't apply PATCHES().
	kernel-2_src_prepare
	eapply "${DISTDIR}/more-uarches-for-kernel-${SHPV}%2B-${PV}.patch"
	eapply "${DISTDIR}/0001-add-sysctl-to-disallow-unprivileged-CLONE_NEWUSER-by-${PV}.patch"
	eapply "${DISTDIR}/0001-mm-Support-soft-dirty-flag-reset-for-VA-range-${PV}.patch"
	eapply "${DISTDIR}/0002-clear-patches-${PV}.patch"
	eapply "${DISTDIR}/0002-mm-Support-soft-dirty-flag-read-with-reset-${PV}.patch"
	eapply "${DISTDIR}/0006-add-acs-overrides_iommu-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-fsync-${PV}.patch"
	eapply "${DISTDIR}/0007-v${SHPV}-winesync-${PV}.patch"
	eapply "${DISTDIR}/0003-glitched-base-${PV}.patch"
	eapply "${DISTDIR}/0001-bbr2-${SHPV}-introduce-BBRv2.patch"
	if use bmq; then
		eapply "${DISTDIR}/0009-prjc_v${SHPV}-r${PRJC_R}-${PV}.patch"
		eapply "${DISTDIR}/0009-glitched-ondemand-bmq-${PV}.patch"
		eapply "${DISTDIR}/0009-glitched-bmq-${PV}.patch"
	fi
	if use pds; then
		eapply "${DISTDIR}/0005-glitched-pds-${PV}.patch"
	fi
	if use bcachefs; then
		eapply "${DISTDIR}/0008-${SHPV}-bcachefs-${PV}.patch"
	fi
	if use cfs; then
		eapply "${DISTDIR}/0003-glitched-base-${PV}.patch"
		eapply "${DISTDIR}/0003-glitched-cfs-${PV}.patch"
		eapply "${DISTDIR}/0003-glitched-cfs-additions-${PV}.patch"
	fi
	if use cjktty; then
		eapply "${DISTDIR}/v1-cjktty-${SHPV}.patch"
	fi
}

pkg_postinst() {
	kernel-2_pkg_postinst
}

