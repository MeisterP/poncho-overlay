# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PV=${PV#*beta}
MY_PN="RimWorld${MY_PV}Linux"
MY_SRC="${MY_PN//${MY_PV}/${MY_PV}b}"

DESCRIPTION="A sci fi colony sim driven by an intelligent AI storyteller"
HOMEPAGE="http://rimworldgame.com/"
SRC_URI="${MY_SRC}.zip"

LICENSE="Unknown"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

DEPEND=""
RDEPEND="virtual/opengl
	virtual/glu
	sys-libs/glibc
	sys-devel/gcc
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/*"

S="${WORKDIR}/${MY_SRC}"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	# TODO: unbundle mono and unity
	insinto "${dir}"
	doins -r ${MY_PN}_Data

	exeinto "${dir}"
	if use x86; then
		doexe ${MY_PN}.x86
		games_make_wrapper ${PN} "./${MY_PN}.x86" "${dir}"
	else
		doexe ${MY_PN}.x86_64
		games_make_wrapper ${PN} "./${MY_PN}.x86_64" "${dir}"
	fi

	newicon -s 256 "${FILESDIR}/rimworld___icon_by_blagoicons-d6xgbs5.png" ${PN}.png
	make_desktop_entry ${PN} "RimWorld"

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
