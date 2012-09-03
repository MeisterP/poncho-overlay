# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

MY_PN=LoneSurvivor
MY_PV=${PV/_p/-}

DESCRIPTION="2D sidescrolling psychological survival adventure game"
HOMEPAGE="http://www.lonesurvivor.co.uk/"
SRC_URI="${PN}-${MY_PV}-${ARCH}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-xlibs
	)
	x86? ( app-arch/bzip2
		media-libs/freetype:2
		media-libs/libpng:0
		sys-libs/zlib
		x11-libs/gtk+:2
		virtual/opengl )"

S="${WORKDIR}/${PN}"

RESTRICT="fetch strip"

pkg_nofetch() {
	ewarn "Please place ${A} to ${DESTDIR}"
}

src_install() {
	local dir="/opt/${MY_PN}"
	dodoc README
	exeinto ${dir}
	doexe ${MY_PN}
	doicon ${MY_PN}.png
	games_make_wrapper ${PN} ./${MY_PN} "${dir}" "${dir}"
	make_desktop_entry ${PN} ${MY_PN} ${MY_PN}

	prepgamesdirs
}
