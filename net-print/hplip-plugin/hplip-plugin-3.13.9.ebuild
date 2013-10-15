# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils multilib unpacker

DESCRIPTION="Proprietary plugins and firmware for HPLIP"
HOMEPAGE="http://hplipopensource.com/hplip-web/index.html"
SRC_URI="http://www.openprinting.org/download/printdriver/auxfiles/HP/plugins/hplip-${PV}-plugin.run
	http://hplipopensource.com/hplip-web/plugin/hplip-${PV}-plugin.run"

LICENSE="hplip-plugin"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="~net-print/hplip-${PV}
	virtual/udev !<sys-fs/udev-114"
DEPEND=""

S=${WORKDIR}

HPLIP_HOME=/usr/share/hplip

# Binary prebuilt package
QA_PRESTRIPPED="
/usr/share/hplip/scan/plugins/bb_marvell.so
/usr/share/hplip/scan/plugins/bb_soapht.so
/usr/share/hplip/scan/plugins/bb_soap.so
/usr/share/hplip/fax/plugins/fax_marvell.so
/usr/share/hplip/prnt/plugins/lj.so"

# License does not allow us to redistribute the "source" package
RESTRICT="mirror"

src_unpack() {
	unpack_makeself "hplip-${PV}-plugin.run"
}

src_install() {
	# Note: to check the install, perform: hp-diagnose_plugin

	local hplip_arch=$(use amd64 && echo 'x86_64' || echo 'x86_32')

	insinto "${HPLIP_HOME}"
	doins plugin.spec

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
