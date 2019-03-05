# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 xdg

DESCRIPTION="GTK MPD (Music Player Daemon) client inspired by Rythmbox"
HOMEPAGE="http://ario-player.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}-player/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus debug +idle python taglib zeroconf"

RDEPEND=">=dev-libs/glib-2.4:2
	dev-libs/libxml2:2
	media-libs/libmpdclient
	net-misc/curl
	x11-libs/gtk+:3
	dev-libs/gobject-introspection
	python? ( dev-python/pygtk:2
		dev-python/pygobject:2 )
	dbus? ( dev-libs/dbus-glib )
	taglib? ( media-libs/taglib )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS )

pkg_setup() {
	python-any-r1_pkg_setup
}

src_configure() {
	econf \
		--disable-xmms2 \
		--enable-libmpdclient2 \
		--enable-search \
		--enable-playlists \
		--disable-deprecations \
		$(use_enable debug) \
		$(use_enable python) \
		$(use_enable idle mpdidle) \
		$(use_enable dbus) \
		$(use_enable zeroconf avahi) \
		$(use_enable taglib)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
