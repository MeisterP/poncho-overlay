# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads zlib"

RDEPEND="media-libs/libsdl[X,sound,video]
	zlib? ( sys-libs/zlib )"

GAMES_DATADIR="/usr/share/ja2"

src_prepare() {
	default
	sed -e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:" \
		-i sgp/SGP.cc || die
}

src_configure() {
	cat <<- EOF > Makefile.config
		BINARY_DIR               := /bin
		MANPAGE_DIR              := /usr/share/man/man6
		SHARED_DIR               := /usr/share
		FULL_PATH_EXTRA_DATA_DIR := ${GAMES_DATADIR}
		INSTALLABLE              := yes
	EOF

	cat <<- EOF > ja2config.h
		#define EXTRA_DATA_DIR "$GAMES_DATADIR"
	EOF
}

src_compile() {
	local myconf

	myconf="WITH_UNITTESTS=0 WITH_DEBUGINFO=0"
	use zlib && myconf+=" WITH_ZLIB=1"
	use threads && myconf+=" WITH_LPTHREAD=1"

	emake ${myconf}
}

src_install() {
	dobin ja2

	insinto "${GAMES_DATADIR}"
	doins -r externalized mods
	keepdir "${GAMES_DATADIR}/data"

	newicon -s scalable _build/icons/logo.svg ${PN}.svg
	domenu _build/distr-files-linux/${PN}.desktop

	newman ja2_manpage ja2.6
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
