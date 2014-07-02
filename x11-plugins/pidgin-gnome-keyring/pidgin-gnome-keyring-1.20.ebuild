# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils

DESCRIPTION="Integrate pidgin and the GNOME keyring"
HOMEPAGE="http://code.google.com/p/pidgin-gnome-keyring/"

SRC_URI="http://${PN}.googlecode.com/files/${P}_src.tar.gz"
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-im/pidgin
	gnome-base/libgnome-keyring"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
}
