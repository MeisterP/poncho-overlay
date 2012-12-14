# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

AUTOMAKE_VERSION="1.11"
PYTHON_DEPEND="2"

inherit subversion gnome2-utils python

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"

LICENSE="GPL-2 GPL-3 BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="css gtk gstreamer ffmpeg"

# fribidi is necessary to compile libass
# Don't need this dependency, net-libs/webkit-gtk,
# since I'm passing --disable-gtk-update-checks to configure.
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	dev-libs/fribidi
	gtk? (	>=x11-libs/gtk+:2
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			virtual/udev[gudev]
	gstreamer? (
		media-libs/gstreamer
		media-libs/gst-plugins-base )"

DEPEND="${RDEPEND}
	sys-devel/automake:1.11
	dev-lang/yasm
	gtk? ( dev-util/intltool )"

pkg_setup() {
	python_set_active_version 2
}

src_configure() {
	# python configure script doesn't accept all econf flags
	local myconf=""

	! use gtk && myconf="${myconf} --disable-gtk"
	! use gstreamer && myconf="${myconf} --disable-gst"
	use ffmpeg && myconf="${myconf} --enable-ff-mpeg2"

	./configure --force --prefix=/usr \
		--disable-gtk-update-checks \
		${myconf} || die "configure failed"
}

src_compile() {
	WANT_AUTOMAKE="${AUTOMAKE_VERSION}" emake -C build || \
		die "failed compiling ${PN}"
}

src_install() {
	emake -C build DESTDIR="${D}" install || die "failed installing ${PN}"
	emake -C build doc || die "emake doc failed"
	dodoc AUTHORS CREDITS NEWS THANKS || die "dodoc 1 failed"
	dodoc build/doc/articles/txt/* || die "dodoc 2 failed"
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
