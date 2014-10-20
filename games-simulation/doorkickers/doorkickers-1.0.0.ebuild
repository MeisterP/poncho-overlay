# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PN="Door Kickers"

DESCRIPTION="A Real-Time Tactics game that puts you in charge of a SWAT team"
HOMEPAGE="http://inthekillhouse.com/doorkickers/"
SRC_URI="${MY_PN/\ /}.tar.gz"

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

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/linux_libs"

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
	doins -r linux_libs

	exeinto "${dir}"
	doexe ${MY_PN/\ /}

	dodoc Version.txt Readme.txt

	for size in 32 48 64 128; do
		newicon -s $size "${FILESDIR}/${MY_PN/\ /}_$size.png" ${PN}.png
	done
	games_make_wrapper ${PN} "./${MY_PN/\ /}" "${dir}"

	make_desktop_entry ${PN} "${MY_PN}"

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
