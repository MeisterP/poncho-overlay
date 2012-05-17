# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

DESCRIPTION="A font management application for the GNOME desktop"
HOMEPAGE="http://code.google.com/p/font-manager"
SRC_URI="http://font-manager.googlecode.com/files/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/python-2.6[sqlite]"
RDEPEND="${DEPEND}
	dev-python/pygtk
	dev-python/pygobject
	dev-python/pycairo
	dev-libs/libxml2[python]
	media-libs/fontconfig
	>=media-libs/freetype-2.3.11
	dev-db/sqlite:3"

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO || die
}
