# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

AUTOMAKE_VERSION="1.11"
PYTHON_DEPEND="2"

inherit subversion gnome2-utils python

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr/"
ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
SRC_CONTRIB="http://download.handbrake.fr/handbrake/contrib/"
SRC_URI="${SRC_CONTRIB}a52dec-0.7.4.tar.gz -> a52dec-0.7.4-${PN}.tar.gz
	${SRC_CONTRIB}faac-1.28.tar.gz -> faac-1.28-${PN}.tar.gz
	${SRC_CONTRIB}lame-3.98.tar.gz -> lame-3.98-${PN}.tar.gz
	${SRC_CONTRIB}libav-v9.1.tar.bz2 -> libav-v9.1-${PN}.tar.bz2
	${SRC_CONTRIB}libbluray-0.2.3.tar.bz2 -> libbluray-0.2.3-${PN}.tar.bz2
	${SRC_CONTRIB}libdvdnav-svn1168.tar.gz -> libdvdnav-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}libdvdread-svn1168.tar.gz -> libdvdread-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}libmkv-0.6.5-0-g82075ae.tar.gz -> libmkv-0.6.5-0-g82075ae-${PN}.tar.gz
	${SRC_CONTRIB}mp4v2-trunk-r355.tar.bz2 -> mp4v2-trunk-r355-${PN}.tar.bz2
	${SRC_CONTRIB}mpeg2dec-0.5.1.tar.gz -> mpeg2dec-0.5.1-${PN}.tar.gz
	${SRC_CONTRIB}x264-r2245-bc13772.tar.gz -> x264-r2245-bc13772-${PN}.tar.gz"
unset SRC_CONTRIB

LICENSE="GPL-2 GPL-3 BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="css gtk gstreamer ffmpeg"

# fribidi is necessary to compile libass
# Don't need this dependency, net-libs/webkit-gtk,
# since I'm passing --disable-gtk-update-checks to configure.
RDEPEND="app-arch/bzip2
	dev-libs/fribidi
	dev-libs/libxml2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libass
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/libtheora
	media-libs/libvorbis
	sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	x11-libs/gtk+:2
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			virtual/udev[gudev] )
	gstreamer? (
		media-libs/gstreamer:0.10
		media-libs/gst-plugins-base:0.10 )"

DEPEND="${RDEPEND}
	sys-devel/automake:1.11
	dev-lang/yasm
	gtk? ( dev-util/intltool )"

pkg_setup() {
	python_set_active_version 2
}

src_prepare() {
	mkdir "${S}"/download || die
	local x
	for x in ${A}; do
		cp "${DISTDIR}/${x}" "${S}/download/${x/-${PN}}" \
		|| die "copying ${x} failed"
	done
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
	WANT_AUTOMAKE="${AUTOMAKE_VERSION}" emake -C build
}

src_install() {
	emake -C build DESTDIR="${D}" install
	emake -C build doc
	dodoc AUTHORS CREDITS NEWS THANKS
	dodoc build/doc/articles/txt/*
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
