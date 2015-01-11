# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils gnome2-utils games vcs-snapshot

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://bitbucket.org/gennady/ja2-stracciatella"
SRC_URI="https://bitbucket.org/gennady/${PN}/get/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads zlib"

RDEPEND="media-libs/libsdl[X,sound,video]
	zlib? ( sys-libs/zlib )"

src_configure() {
	# writing Makefile.config
	echo "# configuration options"                               >Makefile.config
	echo "BINARY_DIR               := $GAMES_PREFIX/bin"         >>Makefile.config
	echo "MANPAGE_DIR              := /usr/share/man/man6"       >>Makefile.config
	echo "FULL_PATH_EXTRA_DATA_DIR := $GAMES_DATADIR/ja2/"       >>Makefile.config
	echo "INSTALLABLE              := yes"                       >>Makefile.config

	# writing ja2config.h
	echo "/* configuration options */"                           >ja2config.h
	echo "#define EXTRA_DATA_DIR \"$GAMES_DATADIR/ja2/\""        >>ja2config.h
}

src_prepare() {
	 sed \
		-e "s:/some/place/where/the/data/is:${GAMES_DATADIR}/ja2:" \
		-i sgp/SGP.cc || die
}

src_compile() {
	local myconf

	myconf="WITH_UNITTESTS=0"
	use zlib && myconf+=" WITH_ZLIB=1"
	use threads && myconf+=" WITH_LPTHREAD=1"

	emake ${myconf}
}

src_install() {
	dogamesbin ja2

	insinto "$GAMES_DATADIR/ja2/"
	doins -r externalized mods
	keepdir "${GAMES_DATADIR}/ja2/data"

	newman ja2_manpage ja2.6
	doicon -s 32 "${FILESDIR}/ja2.png"
	make_desktop_entry ja2 ${PN} ja2.png

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "${GAMES_DATADIR}/ja2/data"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
