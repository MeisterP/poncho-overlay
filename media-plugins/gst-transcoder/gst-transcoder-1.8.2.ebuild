# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="GStreamer Transcoding API"
HOMEPAGE="https://github.com/pitivi/gst-transcoder"
SRC_URI="https://github.com/pitivi/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/gobject-introspection
	dev-libs/glib:2
	>=media-libs/gstreamer-1.8.1
	>=media-libs/gst-plugins-base-1.8.2"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.28.0
	virtual/pkgconfig"

src_configure() {
	mkdir builddir
	meson builddir --buildtype=plain --prefix=/usr
}

src_compile(){
	ninja -C builddir -v
}

src_install(){
	DESTDIR="${D}" ninja -C builddir install
}
