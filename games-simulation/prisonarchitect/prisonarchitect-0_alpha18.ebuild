# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils gnome2-utils games

MY_PN="${PN}-${PV#*_}b-linux"

DESCRIPTION="Build and Manage a Maximum Security Prison"
HOMEPAGE="http://www.introversion.co.uk/prisonarchitect/"
SRC_URI="${MY_PN}.tar.gz"

LICENSE="Introversion"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch bindist splitdebug"

DEPEND="app-arch/unrar
	media-gfx/imagemagick"

RDEPEND="media-libs/libsdl
	virtual/opengl
	virtual/glu
	sys-libs/glibc
	sys-devel/gcc"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/${PN}"

S="${WORKDIR}/${MY_PN}"

pkg_nofetch() {
	einfo "Please buy & download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to ${DISTDIR}"
	einfo
}

src_compile() {
	# an icon... desperately...
	unrar e -inul main.dat data/people.png || die "unrar main.dat failed"
	convert -crop 64x64+1024+704 people.png ${PN}.png || die "convert people.png failed"
}

src_install() {
	local dir=${GAMES_PREFIX_OPT}/${PN}

	insinto "${dir}"
	doins {main,sounds}.dat

	exeinto "${dir}"
	if use x86; then
		newexe PrisonArchitect.i686 prisonarchitect
	else
		newexe PrisonArchitect.x86_64 prisonarchitect
	fi

	doicon -s 64 ${PN}.png
	games_make_wrapper ${PN} "./${PN}" "${dir}"
	make_desktop_entry ${PN} "Prison Architect"

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
