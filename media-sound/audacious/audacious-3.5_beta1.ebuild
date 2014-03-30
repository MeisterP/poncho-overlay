# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.audacious-media-player.org/${MY_P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="nls"

RDEPEND=">=dev-libs/glib-2.30
	dev-libs/libxml2
	dev-util/gdbus-codegen
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	x11-libs/gtk+:3"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( dev-util/intltool )"

PDEPEND="~media-plugins/audacious-plugins-3.5_beta1"

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	econf \
		--enable-dbus \
		--disable-valgrind \
		--disable-chardet \
		$(use_enable nls)
}

src_install() {
	default
	dodoc AUTHORS
}
