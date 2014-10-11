# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit unpacker eutils gnome2-utils games

DESCRIPTION="Roam a vast underground ocean in a customised steamship"
HOMEPAGE="http://www.failbettergames.com/sunless/"
SRC_URI="V${PV}.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

DEPEND=""
RDEPEND="virtual/opengl
	virtual/glu
	sys-libs/glibc
	sys-devel/gcc
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/*"

S="${WORKDIR}"

# add "-x /" to workaround the broken dropbox zip file
unpack_zip() {
	[[ $# -eq 1 ]] || die "Usage: ${FUNCNAME} <file>"

	local zip=$(find_unpackable_file "$1")
	unpack_banner "${zip}"
	unzip -qo "${zip}" -x /

	[[ $? -le 1 ]] || die "unpacking ${zip} failed (arch=unpack_zip)"
}

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
	einfo "For the experimental, unsupported Linux build see:"
	einfo "http://www.failbettergames.com/experimental-linux-builds/"
	einfo
}

src_prepare() {
	cp -rf sunlesssea_data/mono/* sunlesssea_data/Mono || die
	rm -r sunlesssea_data/mono || die
	cp -rf sunlesssea_data/plugins/* sunlesssea_data/Plugins || die
	rm -r sunlesssea_data/plugins || die
	cp -rf sunlesssea_data/* ${PN}_Data || die
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	exeinto "${dir}"
	if use x86; then
		doexe ${PN}.x86
		games_make_wrapper ${PN} "./${PN}.x86" "${dir}"
		rm -r ${PN}_Data/{Mono,Plugins}/x86_64 || die "failed to remove 64bit files"
	else
		doexe ${PN}.x86_64
		games_make_wrapper ${PN} "./${PN}.x86_64" "${dir}"
		rm -r ${PN}_Data/{Mono,Plugins}/x86 || die "failed to remove 32bit files"
	fi

	# TODO: unbundle mono and unity
	insinto "${dir}"
	doins -r ${PN}_Data

	newicon -s 128 ${PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "Sunless Sea"

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
