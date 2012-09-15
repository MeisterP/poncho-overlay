# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

DESCRIPTION="A spaceship simulation roguelike-like"
HOMEPAGE="http://www.ftlgame.com/"
SRC_URI="${PN}.Linux.${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/freetype
	media-libs/libsdl
	media-libs/libpng:1.2"

RESTRICT="fetch strip"

S="${WORKDIR}/${PN}/data"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

src_install() {
	insinto "${GAMEDIR}"
	doins -r resources
	doins exe_icon.bmp # prevent error messages

	exeinto "${GAMEDIR}"/bin
	doexe ${ARCH}/bin/${PN}

	insinto "${GAMEDIR}"/lib
	doins ${ARCH}/lib/libbass{,mix}.so
	doins ${ARCH}/lib/libIL{,U,UT}.so.1

	newicon exe_icon.bmp ${PN}.bmp

	games_make_wrapper "${PN}" "./bin/${PN}" "${GAMEDIR}" "${GAMEDIR}/lib"
	make_desktop_entry ${PN} "${PN}: Faster than Light" "/usr/share/pixmaps/${PN}.bmp"

	prepgamesdirs
}
