# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PN="DoorKickers"

DESCRIPTION="A Real-Time Tactics game that puts you in charge of a SWAT team"
HOMEPAGE="http://inthekillhouse.com/doorkickers//"
SRC_URI="${MY_PN}Alpha.tar.gz"

LICENSE="Unknown"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

DEPEND=""
RDEPEND="sys-libs/glibc
	sys-devel/gcc
	!amd64? (
		media-libs/libsdl
		virtual/opengl
		virtual/glu
		x11-libs/libX11
		x11-libs/libXxf86vm )
	amd64? (
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-xlibs )"

S="${WORKDIR}/${MY_PN}"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r data

	exeinto "${dir}"
	doexe ${MY_PN}

	newicon -s 128 "${FILESDIR}/Door-Kickers.png" ${PN}.png
	games_make_wrapper ${PN} "./${MY_PN}" "${dir}"

	make_desktop_entry ${PN} "Door Kickers"

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
