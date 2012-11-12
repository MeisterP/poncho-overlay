# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games

DESCRIPTION="A spaceship simulation roguelike-like"
HOMEPAGE="http://www.ftlgame.com/"
SRC_URI="ftl-linux-${PV}-1350405106.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/devil
	media-libs/freetype
	media-libs/libsdl
	media-libs/libpng:1.2"

RESTRICT="fetch strip"

S="${WORKDIR}/${PN}/data"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "Download and place ${SRC_URI} in"
	einfo "${DISTDIR}"
}

src_install() {
	insinto "${GAMEDIR}"
	doins -r resources
	doins exe_icon.bmp # prevent error messages

	exeinto "${GAMEDIR}"/bin
	doexe ${ARCH}/bin/${PN}

	insinto "${GAMEDIR}"/lib
	doins ${ARCH}/lib/libbass{,mix}.so # BASS audio library

	dodoc ../FTL_README.html

	newicon exe_icon.bmp ${PN}.bmp

	games_make_wrapper ${PN} "./bin/${PN}" "${GAMEDIR}" "${GAMEDIR}/lib"
	make_desktop_entry ${PN} "${PN}: Faster than Light" "/usr/share/pixmaps/${PN}.bmp"

	prepgamesdirs
}
