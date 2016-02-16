# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://github.com/ja2-stracciatella/ja2-stracciatella"
EGIT_REPO_URI="https://github.com/ja2-stracciatella/ja2-stracciatella.git"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS=""
IUSE="threads zlib"

RDEPEND="media-libs/libsdl[X,sound,video]
	zlib? ( sys-libs/zlib )"

GAMES_DATADIR="/usr/share"

src_prepare() {
	default
	sed -e "s:/some/place/where/the/data/is:${GAMES_DATADIR}/ja2:" \
		-i sgp/SGP.cc || die
}

src_configure() {
	cat <<- EOF > Makefile.config
		BINARY_DIR               := /bin
		MANPAGE_DIR              := /usr/share/man/man6
		FULL_PATH_EXTRA_DATA_DIR := ${GAMES_DATADIR}/ja2/
		INSTALLABLE              := yes
	EOF

	cat <<- EOF > ja2config.h
		#define EXTRA_DATA_DIR "$GAMES_DATADIR/ja2/"
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

	insinto "${GAMES_DATADIR}/ja2/"
	doins -r externalized mods
	keepdir "${GAMES_DATADIR}/ja2/data"

	newman ja2_manpage ja2.6
}

pkg_postinst() {
	games_pkg_postinst

	elog "You need to copy all files from the Data directory of"
	elog "Jagged Alliance 2 installation to"
	elog "${GAMES_DATADIR}/ja2/data"
}
