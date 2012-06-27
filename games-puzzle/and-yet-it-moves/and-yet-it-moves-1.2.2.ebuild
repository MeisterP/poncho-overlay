# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

MY_PN="AndYetItMoves"
MY_REV="-1"

DESCRIPTION="And Yet It Moves is an award-winning physics-based platformer"
HOMEPAGE="http://www.andyetitmoves.net"

SRC_URI="amd64? ( andyetitmoves-${PV}${MY_REV}_x86_64.tar.gz )"
	 #x86? ( andyetitmoves-${PV}${MY_REV}_i386.tar.gz )"

RESTRICT="fetch"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64" #~x86
IUSE=""

DEPEND=""
RDEPEND="( media-libs/libogg
		   media-libs/libpng:1.2
		   media-libs/libsdl[audio,joystick,video]
		   media-libs/libtheora
		   media-libs/libvorbis
		   media-libs/sdl-image[jpeg,png]
		   x11-libs/libX11
		   x11-libs/libXft
		   virtual/opengl )"

S="${WORKDIR}/${MY_PN}"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${A}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_install() {
	# Install data files:
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	find * -maxdepth 0 -type d ! -iname lib -exec doins -r '{}' \; || die "doins data dirs failed"
	# Install needed config files:
	doins *.cs *.frag || die "doins config files failed"

	# Install executables:
	exeinto "${GAMEDIR}" || die "exeinto \"${GAMEDIR}\" failed"
	newexe "lib/${MY_PN}" "${PN}" || die "newexe \"${PN}\" failed"

	# Make and install game wrapper:
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file:
	newicon "icons/128x128.png" "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Setting permissions:
	prepgamesdirs
}

pkg_postinst() {
	echo ""
	games_pkg_postinst
}
