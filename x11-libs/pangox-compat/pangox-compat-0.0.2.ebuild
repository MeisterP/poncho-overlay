# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib toolchain-funcs

DESCRIPTION="Compatibility library for pangox"
HOMEPAGE="http://ftp.gnome.org/pub/GNOME/sources/pangox-compat/0.0/"

LICENSE="LGPL-2+ FTL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-libs/pango-1.32.1[X,introspection]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	tc-export CXX
	DOCS="AUTHORS ChangeLog NEWS README"
	G2CONF="${G2CONF}
		--disable-static
		--x-includes=${EPREFIX}/usr/include
		--x-libraries=${EPREFIX}/usr/$(get_libdir)"

	gnome2_src_prepare
}
