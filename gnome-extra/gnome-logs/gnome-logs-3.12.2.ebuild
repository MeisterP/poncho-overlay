# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Log messages and event viewer"
HOMEPAGE="https://wiki.gnome.org/Apps/Logs"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.39.90:2
	sys-apps/systemd
	>=x11-libs/gtk+-3.9.6:3
"
DEPEND="${RDEPEND}
	~app-text/docbook-xml-dtd-4.3
	dev-libs/libxslt
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

src_configure() {
	gnome2_src_configure ITSTOOL="$(type -P true)"
}
