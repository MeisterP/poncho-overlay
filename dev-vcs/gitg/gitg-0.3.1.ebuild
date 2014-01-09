# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

VALA_MIN_API_VERSION="0.20"
inherit base eutils gnome2 vala

DESCRIPTION="git repository viewer for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Gitg"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
# FIXME: debug changes CFLAGS
IUSE="debug glade"

RDEPEND=">=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.9.0:3
	>=x11-libs/gtksourceview-3.1.3:3.0
	>=gnome-base/gsettings-desktop-schemas-0.1.1
	dev-libs/libgee:0.8
	>=dev-libs/libpeas-1.5.0[gtk]
	>=dev-libs/gobject-introspection-0.10.1
	>=net-libs/webkit-gtk-2.2:3[introspection]
	dev-libs/libgit2[threads]
	>=dev-libs/libgit2-glib-0.0.10
	>=app-text/gtkspell-3.0.3:3
	glade? ( >=dev-util/glade-3.2:3.10 )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
	>=dev-util/intltool-0.40"

DOCS="AUTHORS ChangeLog MAINTAINERS NEWS README"

src_prepare() {
	base_src_prepare
	gnome2_src_prepare
	vala_src_prepare
}

src_configure() {
	# Disable maintainer to get rid of -Werror  (bug #363009)
	G2CONF="${G2CONF}
		--disable-static
		--disable-deprecations
		--disable-dependency-tracking
		$(use_enable debug)
		$(use_enable glade glade-catalog)"

	gnome2_src_configure
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
}

src_test() {
	default
}
