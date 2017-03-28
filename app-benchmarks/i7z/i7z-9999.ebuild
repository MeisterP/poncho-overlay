# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils git-r3 toolchain-funcs

DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="https://github.com/ajaiantilal/i7z"
EGIT_REPO_URI="https://github.com/ajaiantilal/i7z.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="
	sys-libs/ncurses:=
	X? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ncurses.patch )

src_prepare() {
	default
	tc-export CC
}

src_compile() {
	default
	if use X; then
		cd GUI
		eqmake4 ${PN}_GUI.pro
		emake clean && emake
	fi
}

src_install() {
	emake DESTDIR="${ED}" docdir=/usr/share/doc/${PF} install
	use X && dosbin GUI/i7z_GUI
}
