# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PN="DoorKickers"

DESCRIPTION="A Real-Time Tactics game that puts you in charge of a SWAT team"
HOMEPAGE="http://inthekillhouse.com/doorkickers/"
SRC_URI="${MY_PN}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

DEPEND=""
RDEPEND="sys-libs/glibc
	sys-devel/gcc
	|| (
		(
			media-libs/libsdl[abi_x86_32(-)]
			media-libs/openal[abi_x86_32(-)]
			virtual/glu[abi_x86_32(-)]
			virtual/opengl[abi_x86_32(-)]
			x11-libs/libXxf86vm[abi_x86_32(-)]
			x11-libs/libX11[abi_x86_32(-)]
		)
		amd64? (
			app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
			app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
			app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
		)
	)"

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
	doins -r mods

	exeinto "${dir}"
	doexe ${MY_PN}

	dodoc Version.txt Readme.txt

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

	elog "If you are using opensource drivers you should consider installing:"
	elog "    media-libs/libtxc_dxtn"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
