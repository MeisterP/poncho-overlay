# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"

inherit subversion gnome2-utils

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

IUSE="css doc gtk"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/glib
			dev-libs/dbus-glib
			net-libs/webkit-gtk
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
			>=sys-fs/udev-147[extras]
	)"
DEPEND="=sys-devel/automake-1.10*
	=sys-devel/automake-1.4*
	=sys-devel/automake-1.9*
	dev-lang/yasm
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 ) 
	$RDEPEND"

#src_prepare() {
#	epatch "${FILESDIR}/${PN}-dbus-glib.patch"
#	epatch "${FILESDIR}/${PN}-libnotify-0.7.patch"
#	cd gtk
#	eautoreconf
#}

src_configure() {
	local myconf=""

	! use gtk && myconf="${myconf} --disable-gtk"

	./configure --force --prefix=/usr --disable-gtk-update-checks ${myconf} || die "configure failed"
}

src_compile() {
	#WANT_AUTOMAKE=1.9 emake -C build || die "failed compiling ${PN}"
	WANT_AUTOMAKE=1.11 emake -C build || die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"

	if use doc; then
		emake -C build doc
			dodoc AUTHORS CREDITS NEWS THANKS \
				build/doc/articles/txt/* || die "docs failed"
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
