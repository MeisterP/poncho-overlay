# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/mutter/mutter-3.2.2.ebuild,v 1.1 2012/01/21 02:06:12 tetromino Exp $

EAPI="4"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="http://git.gnome.org/browse/mutter/"

LICENSE="GPL-2"
SLOT="0"
IUSE="+introspection shellshape test xinerama"
KEYWORDS=""

COMMON_DEPEND=">=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.10[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.91.7:3[introspection?]
	>=gnome-base/gconf-2:2
	>=dev-libs/glib-2.14:2
	>=media-libs/clutter-1.7.5:1.0
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="${COMMON_DEPEND}
	>=app-text/gnome-doc-utils-0.8
	sys-devel/gettext
	>=dev-util/pkgconfig-0.9
	>=dev-util/intltool-0.35
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto )
	x11-proto/xextproto
	x11-proto/xproto"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity"

pkg_setup() {
	DOCS="AUTHORS ChangeLog HACKING MAINTAINERS NEWS README *.txt doc/*.txt"
	G2CONF="${G2CONF}
		--disable-static
		--enable-gconf
		--enable-shape
		--enable-sm
		--enable-startup-notification
		--enable-xsync
		--enable-verbose-mode
		--enable-compile-warnings=maximum
		--with-libcanberra
		$(use_enable introspection)
		$(use_enable xinerama)"
}

src_prepare() {
	# Compat with Ubuntu metacity themes (e.g. x11-themes/light-themes)
	epatch "${FILESDIR}/${PN}-3.2.1-ignore-shadow-and-padding.patch"
	
	if use shellshape; then
	    epatch "${FILESDIR}/0001-window.c-add-meta_window_move_resize_frame.patch"
	    epatch "${FILESDIR}/0002-added-gir-headers-for-move-resize-window-methods.patch"
	    epatch "${FILESDIR}/0003-workaround-for-super-based-keybindings-not-working.patch"
	    epatch "${FILESDIR}/0004-keybindings-for-shellshape.patch"
	    epatch "${FILESDIR}/0005-add-archive.patch"
	    epatch "${FILESDIR}/0006-Revert-Improve-handling-of-Super-key-combinations.patch"
	    epatch "${FILESDIR}/0007-remove-mutter-dependencies-and-rely-on-the-user-alre.patch"
	    #epatch "${FILESDIR}/0008-commit-ubuntu-specific-04_ignore_shadow_and_padding..patch"
	    epatch "${FILESDIR}/0009-minor-0install-changes.patch"
	    epatch "${FILESDIR}/0010-binary-impl-for-shellshape-0.3.2.patch"
	    epatch "${FILESDIR}/0011-bumped-version-for-0compiled-version-to-trump-binary.patch"
	    epatch "${FILESDIR}/0012-add-shortcut-for-vertical-tiled-layout.patch"
	fi

	gnome2_src_prepare
}
