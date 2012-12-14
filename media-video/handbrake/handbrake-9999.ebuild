# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"

AUTOMAKE_VERSION="1.11"
PYTHON_DEPEND="2"

inherit subversion gnome2-utils python


DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS=""

IUSE="css gtk gst ffmpeg2"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
			>=sys-fs/udev-171[gudev]
	)"
DEPEND="=sys-devel/automake-1.11*
	=sys-devel/automake-1.4*
	=sys-devel/automake-1.9*
	dev-lang/yasm
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 ) 
	$RDEPEND"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	local myconf=""

	! use gtk && myconf="${myconf} --disable-gtk"
	! use gst && myconf="${myconf} --disable-gst"
	use ffmpeg2 && myconf="${myconf} --enable-ff-mpeg2"

	./configure --force --prefix=/usr \
		--disable-gtk-update-checks \
		${myconf} || die "configure failed"
}

src_compile() {
	WANT_AUTOMAKE="${AUTOMAKE_VERSION}" \
		emake -C build || die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"

	emake -C build doc
	dodoc AUTHORS CREDITS NEWS THANKS \
		build/doc/articles/txt/* || die "docs failed"
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
