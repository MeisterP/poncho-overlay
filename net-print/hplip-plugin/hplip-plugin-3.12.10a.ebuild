# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils multilib toolchain-funcs udev unpacker

DESCRIPTION="Proprietary plugins and firmware for HPLIP"
HOMEPAGE="http://hplipopensource.com/hplip-web/index.html"
SRC_URI="http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-${PV}-plugin.run"

LICENSE="hplip-plugin"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="~net-print/hplip-${PV}
	sys-fs/udev"

HPLIP_HOME=/usr/share/hplip

# Binary prebuilt package
KEYWORDS="-* ~amd64 ~x86"
QA_PRESTRIPPED="
/usr/share/hplip/scan/plugins/bb_marvell.so
/usr/share/hplip/scan/plugins/bb_soapht.so
/usr/share/hplip/scan/plugins/bb_soap.so
/usr/share/hplip/fax/plugins/fax_marvell.so
/usr/share/hplip/prnt/plugins/hbpl1.so
/usr/share/hplip/prnt/plugins/lj.so"

# License does not allow us to redistribute the "source" package
RESTRICT="mirror"

S=${WORKDIR}

src_unpack() {
	unpack_makeself "hplip-${PV}-plugin.run"
}

src_install() {
	local hplip_arch=$(use amd64 && echo 'x86_64' || echo 'x86_32')

	udev_dorules *.rules

	insinto "${HPLIP_HOME}"/data/firmware
	doins *.fw.gz

	for plugin in *-${hplip_arch}.so; do
		local plugin_type=prnt
		case "${plugin}" in
			fax_*) plugin_type=fax ;;
			bb_*)  plugin_type=scan ;;
		esac

		exeinto "${HPLIP_HOME}"/${plugin_type}/plugins
		newexe ${plugin} ${plugin/-${hplip_arch}}
	done

	cat <<- EOF > "${WORKDIR}/hplip.state"
		[plugin]
		installed = 1
		eula = 1
		version = ${PV}
	EOF

	insinto /var/lib/hp
	doins hplip.state
}
