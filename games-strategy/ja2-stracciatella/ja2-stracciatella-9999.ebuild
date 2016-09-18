# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils cmake-utils git-r3

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
EGIT_REPO_URI="https://github.com/ja2-stracciatella/ja2-stracciatella.git"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-libs/boost
	media-libs/libsdl[X,sound,video]"

RDEPEND="${DEPEND}"

PATCHES=( ${FILESDIR}/0.15.0-skip-unittest-install.patch )
DOCS=( README.md changes.md contributors.txt)

GAMES_DATADIR="/usr/share/ja2"

src_prepare() {
	default
	sed -e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:" \
		-i sgp/SGP.cc || die
}

src_configure() {
	local mycmakeargs=(
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DLOCAL_BOOST_LIB=OFF
		-DWITH_UNITTESTS=OFF
		-DWITH_FIXMES=OFF
		-DWITH_MAEMO=OFF
	)

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	keepdir "${GAMES_DATADIR}/data"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "${GAMES_DATADIR}/data"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
