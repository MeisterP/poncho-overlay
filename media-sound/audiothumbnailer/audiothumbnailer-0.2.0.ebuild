# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Lightweight audio thumbnailer that can be used by file managers"
HOMEPAGE="http://code.google.com/p/audiothumbnailer/"
SRC_URI="http://audiothumbnailer.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-gfx/imagemagick \
	media-libs/lcms \
	media-libs/taglib \
	media-libs/tiff \
	virtual/jpeg"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/ImageMagick-include.patch
}

src_install() {
	default

	insinto /usr/share/thumbnailers
	doins "${FILESDIR}"/audio.thumbnailer
}
