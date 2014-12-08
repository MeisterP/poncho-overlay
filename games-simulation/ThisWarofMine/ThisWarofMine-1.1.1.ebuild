# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="In war, not everyone is a soldier"
HOMEPAGE="http://www.11bitstudios.com/games/16/this-war-of-mine"
SRC_URI="${PN}_linux_v${PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist strip"

QA_PREBUILT="${GAMES_PREFIX_OPT#/}/${PN}/*"

RDEPEND="
	|| (
		(
			media-libs/openal[abi_x86_32(-)]
			virtual/opengl[abi_x86_32(-)]
			x11-libs/libX11[abi_x86_32(-)]
			x11-libs/libXau[abi_x86_32(-)]
			x11-libs/libXext[abi_x86_32(-)]
			x11-libs/libdrm[abi_x86_32(-)]
			x11-libs/libxcb[abi_x86_32(-)]
		)
		amd64? (
			app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
			app-emulation/emul-linux-x86-sdl[-abi_x86_32(-)]
			app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
		)
	)"

S="${WORKDIR}/This War of Mine"

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_unpack() {
	default
	unpack "./Linux/This War of Mine.tar.gz"
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r *.{dat,idx,str}

	dosym /usr/lib32/libopenal.so "${dir}"/libOpenAL.so

	exeinto "${dir}"
	doexe "This War of Mine"

	dodoc Changelog.txt
	newicon -s 256 "${FILESDIR}/this_war_of_mine_by_gaben222222-d86ekxw.png" ${PN}.png

	games_make_wrapper ${PN} "\"./This War of Mine\"" "${dir}" "${dir}"
	make_desktop_entry ${PN} "This War of Mine"

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
	elog "    and set the environment variable force_s3tc_enable=true"

	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
