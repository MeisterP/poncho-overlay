# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils gnome2-utils git-2

DESCRIPTION="Tiling window manager extension for GNOME Shell"
HOMEPAGE="http://gfxmonk.net/shellshape/"
EGIT_REPO_URI="https://github.com/gfxmonk/shellshape.git"
EGIT_BRANCH="3.2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""

COMMON_DEPEND="
        >=dev-libs/glib-2.26
        >=gnome-base/gnome-desktop-3:3"
RDEPEND="${COMMON_DEPEND}
        gnome-base/gnome-desktop:3[introspection]
        media-libs/clutter:1.0[introspection]
        net-libs/telepathy-glib[introspection]
        x11-libs/gtk+:3[introspection]
        x11-libs/pango[introspection]
		x11-wm/mutter[shellshape]"
DEPEND="${COMMON_DEPEND}
        sys-devel/gettext
        >=dev-util/pkgconfig-0.22
        >=dev-util/intltool-0.26
        gnome-base/gnome-common"


src_configure() {
		:
}

src_compile()   {
        :
}


src_install()   {
        insinto /usr/share/gnome-shell/extensions/shellshape@gfxmonk.net
        doins shellshape/*.{js,json}
		
		insinto /usr/share/gnome-shell/js
		doins lib/*.js
		
		#insinto /usr/share/glib-2.0/schemas
		#doins schemas/*.xml
		
		insinto /usr/share/icons/hicolor/scalable/status
		doins icons/status/*.svg
		
		dodoc README.md
}

pkg_preinst() {
		#gnome2_schemas_savelist
		gnome2_icon_savelist
}

pkg_postinst() {
		#gnome2_schemas_update
		gnome2_icon_cache_update
}

pkg_postrm() {
		#gnome2_schemas_update --uninstall
		gnome2_icon_cache_update
}

