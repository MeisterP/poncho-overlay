# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils flag-o-matic qt4-r2 subversion toolchain-funcs

DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="http://code.google.com/p/i7z/"
SRC_URI=""
ESVN_REPO_URI="http://i7z.googlecode.com/svn/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="
	sys-libs/ncurses
	X? ( dev-qt/qtgui:4 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-ncurses.patch
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
