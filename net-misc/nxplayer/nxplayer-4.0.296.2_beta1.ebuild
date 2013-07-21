# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils gnome2-utils multilib versionator

MAJOR_PV="$(get_version_component_range 1-3)"
FULL_PV="${MAJOR_PV}_$(get_version_component_range 4)"

DESCRIPTION="New NX client interface"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="amd64? ( http://64.34.173.142/download/4.0/Linux/nomachine_${FULL_PV}_beta1_x86_64.tar.gz )
	x86? ( http://64.34.173.142/download/4.0/Linux/nomachine_${FULL_PV}_beta1_i686.tar.gz )"

LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXau"

S=${WORKDIR}/NX

src_unpack() {
	default
	mv "${WORKDIR}"/NX/etc/NX/server/packages/nx{client,player}.tar.gz "${WORKDIR}"
	cd "${WORKDIR}" && unpack ./nx{client,player}.tar.gz
}

src_install() {
	local NXROOT=/opt/NX

	into ${NXROOT}
	dobin bin/nx*
	dolib.so lib/* # needs some unbundling
	dosym ${NXROOT}/$(get_libdir) ${NXROOT}/lib

	insinto ${NXROOT}/share
	doins -r share/{images,keys}

	insinto ${NXROOT}/etc
	doins etc/version

	for size in 16 22 32 48; do
		doicon -s ${size} share/icons/${size}x${size}/NoMachine-icon.png
	done

	make_wrapper ${PN} ./${PN} ${NXROOT}/bin ${NXROOT}/lib /usr/bin
	make_desktop_entry ${PN} "NX Player" NoMachine-icon
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
