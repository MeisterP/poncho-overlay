# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit games gnome2-utils

DESCRIPTION="Superbrothers: Sword & Sworcery EP"
HOMEPAGE="http://www.swordandsworcery.com"
SRC_URI="${PN}_${PV}.tar.gz"

LICENSE="EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-bundled-libs"

DEPEND=""
RDEPEND="amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-opengl
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs
	)"

RESTRICT="fetch strip"

QA_PREBUILT="opt/${PN}/lib/*"
S="${WORKDIR}"

pkg_nofetch() {
	elog "Download and place ${SRC_URI} in"
	elog "${DISTDIR}"
	echo
}

src_prepare() {
	if ! use bundled-libs; then
		rm -f lib/libcurl.so lib/libSDL* lib/libstdc++*
		use x86 && rm liblua*
		# On x86 it might also be possible to use media-libs/fmod
	fi
}

src_install() {
	local instdir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${instdir}"
	doins -r lib res

	exeinto "${instdir}/bin"
	doexe "bin/${PN}"
	exeinto "${instdir}"
	doexe run.sh

	newicon -s 256 "${FILESDIR}"/icon_256.png ${PN}.png
	games_make_wrapper "${PN}" "./run.sh" "${instdir}"
	make_desktop_entry "${PN}" "Sword & Sworcery EP" "${PN}" "Game"

	dodoc README.html eula.txt
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
