# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games multilib

DESCRIPTION="Bring a sleeping planet back to life"
HOMEPAGE="http://www.tigerstylegames.com/wakingmars/"

SLOT="0"
LICENSE="EULA"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="fetch"
IUSE="multilib"

SRC_URI="WakingMars-${PV}-Linux.tar.gz"

RDEPEND="
	app-arch/bzip2
	dev-libs/json-c
	media-libs/alsa-lib
	media-libs/flac
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsdl
	media-libs/libsndfile
	media-libs/libvorbis
	virtual/opengl
	media-sound/pulseaudio
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libXxf86vm
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)
"
DEPEND="${RDEPEND}"

MY_PN="${PN//-}"
S="${WORKDIR}/WakingMars-${PV}-Linux/${MY_PN}"

REQUIRED_USE="amd64? ( multilib )"
pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe "${MY_PN}"
	doicon "${MY_PN}.png"
	rm "${MY_PN}" "${MY_PN}.png"
	doins -r GameData lib

	games_make_wrapper "${PN}" "./${MY_PN}" "${dir}" "${dir}/lib"
	make_desktop_entry "${PN}" "Waking Mars" "${MY_PN}"

	dodoc "../README.txt"
	prepgamesdirs
}
