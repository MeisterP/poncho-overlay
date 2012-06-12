# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils multilib

DESCRIPTION="Proprietary plugins and firmware for HPLIP"
HOMEPAGE="http://hplipopensource.com/hplip-web/index.html"
SRC_URI="http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-${PV}-plugin.run"

LICENSE="hplip-plugin"
SLOT="0"
IUSE=""

RDEPEND="~net-print/hplip-${PV}
	sys-fs/udev"
DEPEND=""

HPLIP_HOME=/usr/share/hplip

# Binary prebuilt package
KEYWORDS="-* ~amd64 ~x86"
QA_PRESTRIPPED="
/usr/share/hplip/scan/plugins/bb_marvell.so
/usr/share/hplip/scan/plugins/bb_soapht.so
/usr/share/hplip/scan/plugins/bb_soap.so
/usr/share/hplip/fax/plugins/fax_marvell.so
/usr/share/hplip/prnt/plugins/lj.so"

# License does not allow us to redistribute the "source" package
RESTRICT="mirror"

src_unpack() {
	unpack_makeself "hplip-${PV}-plugin.run" || die 'unpack failed'
}

src_prepare() {
	sed -i -e 's/SYSFS/ATTR/g' *.rules || die
}

src_install() {
	local hplip_arch=$(use amd64 && echo 'x86_64' || echo 'x86_32')

	insinto /$(get_libdir)/udev/rules.d
	doins *.rules || die

	insinto "${HPLIP_HOME}"/data/firmware
	doins *.fw.gz || die

	for plugin in *-${hplip_arch}.so; do
		local plugin_type=prnt
		case "${plugin}" in
			fax_*) plugin_type=fax ;;
			bb_*)  plugin_type=scan ;;
		esac

		exeinto "${HPLIP_HOME}"/${plugin_type}/plugins
		newexe ${plugin} ${plugin/-${hplip_arch}} || die "failed to install ${plugin}"
	done
}
