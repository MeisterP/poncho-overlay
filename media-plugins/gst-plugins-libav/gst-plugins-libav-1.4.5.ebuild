# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
inherit eutils flag-o-matic multilib-minimal

MY_PN="gst-libav"
DESCRIPTION="FFmpeg based gstreamer plugin"
HOMEPAGE="http://gstreamer.freedesktop.org/modules/gst-libav.html"
SRC_URI="http://gstreamer.freedesktop.org/src/${MY_PN}/${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-2"
SLOT="1.0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="+orc"

RDEPEND="
	>=media-libs/gstreamer-1.4.0:1.0[${MULTILIB_USEDEP}]
	>=media-libs/gst-plugins-base-1.4.0:1.0[${MULTILIB_USEDEP}]
	orc? ( >=dev-lang/orc-0.4.17[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/gtk-doc-am-1.12
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

multilib_src_configure() {
	GST_PLUGINS_BUILD=""
	# crashing with ffmpeg, use bundled libav :-(
	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--with-package-name="Gentoo GStreamer ebuild" \
		--with-package-origin="http://www.gentoo.org" \
		--disable-fatal-warnings \
		--without-system-libav \
		$(use_enable orc)
}

multilib_src_compile() {
	# Don't build with -Werror
	emake ERROR_CFLAGS=
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files --modules
}
