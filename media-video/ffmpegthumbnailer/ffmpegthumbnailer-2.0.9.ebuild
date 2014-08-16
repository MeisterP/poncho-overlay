# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils libtool

DESCRIPTION="Lightweight video thumbnailer that can be used by file managers"
HOMEPAGE="http://code.google.com/p/ffmpegthumbnailer/"
SRC_URI="https://docs.google.com/uc?export=download&id=0B-HAKhnW2w9WMWVsdmhRdHJsOHM -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome gtk jpeg png"

COMMON_DEPEND=">=virtual/ffmpeg-0.10.2
	png? ( media-libs/libpng:0= )
	jpeg? ( virtual/jpeg )"
RDEPEND="${COMMON_DEPEND}
	gtk? ( >=dev-libs/glib-2.30 )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"
REQUIRED_USE="gnome? ( gtk )"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	elibtoolize
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable png) \
		$(use_enable jpeg) \
		$(use_enable gtk gio) \
		$(use_enable gnome thumbnailer)
}

src_install() {
	default
	prune_libtool_files --all
}
