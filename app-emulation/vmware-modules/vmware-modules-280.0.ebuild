# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic linux-info linux-mod user versionator udev

PV_MAJOR=$(get_major_version)
PV_MINOR=$(get_version_component_range 2)

DESCRIPTION="VMware kernel modules"
HOMEPAGE="http://www.vmware.com/"

SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pax_kernel"

RDEPEND=""
DEPEND="${RDEPEND}
	|| ( =app-emulation/vmware-player-7.0.${PV_MINOR}*
	=app-emulation/vmware-workstation-11.0.${PV_MINOR}* )"

S=${WORKDIR}

# no debug-symbol magic (should really be a linux-mod feature)
RESTRICT="strip splitdebug"

# override setup_allowed_flags from flag-o-matic
# to ultra-conservative set.  Interim solution until
# something can be done for this in linux-mod.eclass.
# Note that the kernel has it's own flags that should
# be applied automagically.
#
# How is this still not handled correctly in Gentoo?
# Am I missing something, or is this an insane,
# crazy bug?
setup_allowed_flags() {
	ALLOWED_FLAGS="-pipe"
	ALLOWED_FLAGS+=" -O -O1 -O2 -Os -mtune*"
	ALLOWED_FLAGS+=" -W* -w"
	export ALLOWED_FLAGS
	return 0
}

pkg_setup() {
	CONFIG_CHECK="~HIGH_RES_TIMERS"
	if kernel_is ge 2 6 37 && kernel_is lt 2 6 39; then
		CONFIG_CHECK="${CONFIG_CHECK} BKL"
	fi

	CONFIG_CHECK="${CONFIG_CHECK} VMWARE_VMCI VMWARE_VMCI_VSOCKETS"

	linux-info_pkg_setup

	linux-mod_pkg_setup

	VMWARE_GROUP=${VMWARE_GROUP:-vmware}

	VMWARE_MODULE_LIST_ALL="vmblock vmmon vmnet vmci vsock"
	VMWARE_MODULE_LIST="vmmon vmnet"

	VMWARE_MOD_DIR="${PN}-${PVR}"

	BUILD_TARGETS="auto-build KERNEL_DIR=${KERNEL_DIR} KBUILD_OUTPUT=${KV_OUT_DIR}"

	enewgroup "${VMWARE_GROUP}"
	strip-flags

	for mod in ${VMWARE_MODULE_LIST}; do
		MODULE_NAMES="${MODULE_NAMES} ${mod}(misc:${S}/${mod}-only)"
	done
}

src_unpack() {
	cd "${S}"
	for mod in ${VMWARE_MODULE_LIST_ALL}; do
		tar -xf /opt/vmware/lib/vmware/modules/source/${mod}.tar
	done
}

src_prepare() {
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-kernel-dir.patch"
	epatch "${FILESDIR}/${PV_MAJOR}-makefile-include.patch"
	use pax_kernel && epatch "${FILESDIR}/${PV_MAJOR}-hardened.patch"

	epatch "${FILESDIR}/${PV_MAJOR}-kernel-3.19.patch"

	# Allow user patches so they can support RC kernels and whatever else
	epatch_user
}

src_install() {
	linux-mod_src_install
	local udevrules="${T}/60-vmware.rules"
	cat > "${udevrules}" <<-EOF
		KERNEL=="vmw_vmci",  GROUP="vmware", MODE="0660"
		KERNEL=="vmmon", GROUP="vmware", MODE="0660"
		KERNEL=="vsock", GROUP="vmware", MODE="0660"
	EOF
	udev_dorules "${udevrules}"
}
