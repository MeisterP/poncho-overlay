# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils gnome2-utils git-2

DESCRIPTION="Weather extensions for GNOME Shell"
HOMEPAGE="http://github.com/simon04/gnome-shell-extension-weather"
EGIT_REPO_URI="http://github.com/simon04/gnome-shell-extension-weather"
EGIT_BRANCH="gnome3.4"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEPEND="
		>=dev-libs/glib-2.26
		>=gnome-base/gnome-desktop-3:3"
RDEPEND="${COMMON_DEPEND}
		gnome-base/gnome-desktop:3[introspection]
		media-libs/clutter:1.0[introspection]
		net-libs/telepathy-glib[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]"
DEPEND="${COMMON_DEPEND}
		sys-devel/gettext
		virtual/pkgconfig
		>=dev-util/intltool-0.26
		gnome-base/gnome-common"

#src_prepare() {
#		epatch ${FILESDIR}/convert-wind-degrees-to-compass-direction.patch
#}

src_configure() {
		:
}

src_compile()   {
		./autogen.sh --prefix=/usr
		emake
}

src_install()   {
		mv weather-extension-configurator{.py,}
		dobin weather-extension-configurator

		einstall

		rm "${D}"/usr/share/glib-2.0/schemas/gschemas.compiled
}

pkg_preinst() {
		gnome2_schemas_savelist
}

pkg_postinst() {
		gnome2_schemas_update
}

pkg_postrm() {
		gnome2_schemas_update --uninstall
}
