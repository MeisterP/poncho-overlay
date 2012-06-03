# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit gnome2-utils eutils autotools

MY_PN="HandBrake"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_HB="http://download.handbrake.fr/handbrake/contrib/"

DESCRIPTION="Open-source DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
SRC_URI="http://handbrake.fr/rotation.php?file=${MY_PN}-${PV}.tar.bz2
		-> ${MY_PN}-${PV}.tar.bz2
		${SRC_HB}a52dec-0.7.4.tar.gz -> a52dec-0.7.4-${P}.tar.gz
		${SRC_HB}ffmpeg-v0.7-1696-gcae4f4b.tar.bz2
		${SRC_HB}libdca-r81-strapped.tar.gz
		${SRC_HB}libdvdnav-svn1168.tar.gz
		${SRC_HB}libdvdread-svn1168.tar.gz
		${SRC_HB}libmkv-0.6.5-0-g82075ae.tar.gz
		${SRC_HB}mp4v2-trunk-r355.tar.bz2
		${SRC_HB}mpeg2dec-0.5.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="css doc gtk"
RDEPEND="sys-libs/zlib
	css? ( media-libs/libdvdcss )
	gtk? (	>=x11-libs/gtk+-2.8
			dev-libs/glib
			dev-libs/dbus-glib
			x11-libs/libnotify
			media-libs/gstreamer
			media-libs/gst-plugins-base
			>=sys-fs/udev-147 )
	>=media-libs/libass-0.10.0[fontconfig]
	dev-libs/libxml2
	media-libs/libbluray
	media-sound/lame
	media-libs/libogg
	media-libs/libsamplerate
	media-libs/faac
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/x264"
DEPEND="=sys-devel/automake-1.11*
	dev-lang/yasm
	dev-libs/fribidi
	>=dev-lang/python-2.4.6
	|| ( >=net-misc/wget-1.11.4 >=net-misc/curl-7.19.4 )
	$RDEPEND"

src_prepare() {
	# Handbrake attempts to download tarballs itself in its build system,
	# so copy them to the expected location instead.
	mkdir "${S}"/download
	for x in ${A}; do
		cp "${DISTDIR}"/${x} "${S}"/download/ || die "copying failed"
	done
	cp "${DISTDIR}"/a52dec-0.7.4-${P}.tar.gz \
		"${S}"/download/a52dec-0.7.4.tar.gz || die "copying died"

	epatch "${FILESDIR}"/Fix-make-and-test.patch
	epatch "${FILESDIR}"/Remove-contrib.patch
	epatch "${FILESDIR}"/Fix-for-compilation-with-libbluray.patch
}

src_unpack() {
	# Don't waste time unpacking all the tarballs, when we just
	# need the handbrake one.
	unpack ${MY_PN}-${PV}.tar.bz2
}

src_configure() {
	# Python configure script doesn't accept all econf flags
	./configure --force --prefix=/usr \
        --disable-gtk-update-checks \
		$(use_enable gtk) \
		|| die "configure failed"
}

src_compile() {
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
