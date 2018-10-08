# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils git-r3 toolchain-funcs

DESCRIPTION="A better i7 (and now i3, i5) reporting tool for Linux"
HOMEPAGE="https://github.com/ajaiantilal/i7z"
EGIT_REPO_URI="https://github.com/ajaiantilal/i7z.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ncurses.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" docdir=/usr/share/doc/${PF} install
}
