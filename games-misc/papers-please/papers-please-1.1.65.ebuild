# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

DESCRIPTION="A Dystopian Document Thriller"
HOMEPAGE="http://papersplea.se"
SRC_URI="papers-please_${PV}_i386.tar.gz"

LICENSE="PAPERS-PLEASE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist"

QA_PREBUILT="${GAMES_PREFIX_OPT#/}/${PN}/*"

RDEPEND="
	|| (
		(
			x11-libs/libX11[abi_x86_32(-)]
			x11-libs/libXau[abi_x86_32(-)]
			x11-libs/libXdmcp[abi_x86_32(-)]
			x11-libs/libXext[abi_x86_32(-)]
			x11-libs/libXxf86vm[abi_x86_32(-)]
			x11-libs/libdrm[abi_x86_32(-)]
			x11-libs/libxcb[abi_x86_32(-)]
			virtual/opengl[abi_x86_32(-)]
		)
		amd64? (
			app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)]
			app-emulation/emul-linux-x86-xlibs[-abi_x86_32(-)]
		)
	)"

S=${WORKDIR}/${PN}

pkg_nofetch() {
	einfo
	einfo "Please buy & download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo
}

src_prepare() {
	rm -v launch.sh LICENSE || die
	mv README "${T}"/README || die
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins -r *
	fperms +x "${dir}"/PapersPlease

	newicon -s 256 "${FILESDIR}/papers_please___icon_by_chrisjahim-d6to4j4.png" ${PN}.png

	games_make_wrapper ${PN} "./PapersPlease" "${dir}" "${dir}"
	make_desktop_entry ${PN} "Papers, Please"

	dodoc "${T}"/README

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
