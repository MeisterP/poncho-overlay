# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

MY_PN="Osmos"
MY_P="${MY_PN}_${PV}"

DESCRIPTION="Play as a single-celled organism absorbing others"
HOMEPAGE="http://www.hemispheregames.com/osmos/"
SRC_URI="${MY_P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"
PROPERTIES="interactive"

RDEPEND="virtual/opengl
	virtual/glu
	x11-libs/libX11
	media-libs/freetype:2
	sys-libs/glibc
	media-libs/openal
	media-libs/libvorbis"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_PN}

GAMES_CHECK_LICENSE="yes"

pkg_nofetch() {
	einfo "Please download ${MY_P}.tar.gz and place it into ${DISTDIR}"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	exeinto "${dir}"
	doexe ${MY_PN}
	if use amd64 ; then
		doexe ${MY_PN}.bin64 || die "doexe"
	fi
	if use x86 ; then
		doexe ${MY_PN}.bin32 || die "doexe"
	fi
	dohtml readme.html
	insinto "${dir}"
	doins -r Fonts/ Sounds/ Textures/ Osmos-* *.cfg || die "doins failed"

	newicon Icons/256x256.png ${PN}.png

	games_make_wrapper ${PN} ./${MY_PN} "${dir}"
	make_desktop_entry ${PN} "Osmos"

	prepgamesdirs
}
