# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils gnome2-utils multilib versionator

MY_PV="$(replace_version_separator 3 '_')"

DESCRIPTION="New NX client interface"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="amd64? ( http://64.34.173.142/download/4.1/Linux/nomachine_${MY_PV}_x86_64.tar.gz )
	x86? ( http://64.34.173.142/download/4.1/Linux/nomachine_${MY_PV}_i686.tar.gz )"

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

QA_PREBUILT="opt/NX/bin/*
	opt/NX/lib*/*"

S=${WORKDIR}/NX

src_unpack() {
	default
	mv "${WORKDIR}"/NX/etc/NX/server/packages/nx{client,player}.tar.gz "${WORKDIR}" || die
	cd "${WORKDIR}" && unpack ./nx{client,player}.tar.gz || die
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
