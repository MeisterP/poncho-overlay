# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

AUTOMAKE_VERSION="1.11"
PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit subversion gnome2-utils python-any-r1

DESCRIPTION="Open-source DVD to MPEG-4 converter."
HOMEPAGE="http://handbrake.fr"
ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
SRC_CONTRIB="http://download.handbrake.fr/handbrake/contrib"
SRC_URI="${SRC_CONTRIB}/a52dec-0.7.4.tar.gz -> a52dec-0.7.4-${PN}.tar.gz
	${SRC_CONTRIB}/faac-1.28.tar.gz -> faac-1.28-${PN}.tar.gz
	${SRC_CONTRIB}/fdk-aac-v0.1.1-6-gbae4553.tar.bz2 -> fdk-aac-v0.1.1-6-gbae4553-${PN}.tar.bz2
	${SRC_CONTRIB}/lame-3.98.tar.gz -> lame-3.98-${PN}.tar.gz
	${SRC_CONTRIB}/libav-v9.3.tar.bz2 -> libav-v9.3-${PN}.tar.bz2
	${SRC_CONTRIB}/libbluray-0.2.3.tar.bz2 -> libbluray-0.2.3-${PN}.tar.bz2
	${SRC_CONTRIB}/libdvdnav-svn1168.tar.gz -> libdvdnav-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}/libdvdread-svn1168.tar.gz -> libdvdread-svn1168-${PN}.tar.gz
	${SRC_CONTRIB}/libmkv-0.6.5-0-g82075ae.tar.gz -> libmkv-0.6.5-0-g82075ae-${PN}.tar.gz
	${SRC_CONTRIB}/mp4v2-trunk-r355.tar.bz2 -> mp4v2-trunk-r355-${PN}.tar.bz2
	${SRC_CONTRIB}/mpeg2dec-0.5.1.tar.gz -> mpeg2dec-0.5.1-${PN}.tar.gz
	${SRC_CONTRIB}/x264-r2273-b3065e6.tar.gz -> x264-r2273-b3065e6-${PN}.tar.gz"
unset SRC_CONTRIB

LICENSE="GPL-2 GPL-3 BSD MIT"
SLOT="0"
KEYWORDS=""
IUSE="css fdk ffmpeg gstreamer gtk"

# dev-libs/fribidi is necessary to compile libass
# net-libs/webkit-gtk isn't necessary with --disable-gtk-update-checks
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

	use fdk && myconf+=" --enable-fdk-aac"
	use ffmpeg && myconf+=" --enable-ff-mpeg2"
	use gtk || myconf+=" --disable-gtk"
	use gstreamer || myconf+=" --disable-gst"

	./configure --force \
		--prefix=/usr \
		--disable-gtk-update-checks \
		${myconf} || die "configure failed"
}

src_compile() {
	# prevent the buildsystem from downloading sources
	# update SRC_URI in case of sandbox errors
	adddeny /usr/bin/wget
	adddeny /usr/bin/curl

	WANT_AUTOMAKE="${AUTOMAKE_VERSION}" emake -C build
}

src_install() {
	emake -C build DESTDIR="${D}" install
	dodoc AUTHORS CREDITS NEWS THANKS
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
