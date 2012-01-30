# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/audacious/audacious-3.1.1.ebuild,v 1.2 2012/01/17 12:55:52 klausman Exp $

EAPI=4

inherit git-2

MY_P="${P/_/-}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="Audacious Player - Your music, your way, no exceptions"
HOMEPAGE="https://github.com/audacious-media-player/audacious/"
EGIT_REPO_URI="https://github.com/audacious-media-player/audacious.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="chardet nls session"

RDEPEND=">=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.16
	dev-libs/libxml2
	>=x11-libs/cairo-1.2.6
	>=x11-libs/pango-1.8.0
	x11-libs/gtk+:3
	session? ( x11-libs/libSM )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.9.0
	chardet? ( >=app-i18n/libguess-1.1 )
	nls? ( dev-util/intltool )"

PDEPEND=">=media-plugins/audacious-plugins-3.2"

src_prepare () {
	./autogen.sh
}

src_configure() {
	# D-Bus is a mandatory dependency, remote control,
	# session management and some plugins depend on this.
	# Building without D-Bus is *unsupported* and a USE-flag
	# will not be added due to the bug reports that will result.
	# Bugs #197894, #199069, #207330, #208606
	# Use of GTK+2 causes plugin build failures, bug #384185
	econf \
		--enable-dbus \
		--enable-gtk3 \
		$(use_enable chardet) \
		$(use_enable nls) \
		$(use_enable session sm)
}

src_install() {
	default
	dodoc AUTHORS README
}
