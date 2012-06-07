# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libvdpau/libvdpau-0.4.1-r1.ebuild,v 1.1 2012/02/15 14:41:04 scarabeus Exp $

EAPI=4
inherit multilib eutils

DESCRIPTION="VDPAU wrapper and trace libraries"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="http://people.freedesktop.org/~aplattner/vdpau/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86 ~x86-fbsd"
IUSE="doc"

#unfortunately, there's driver versions in between that this works with
RDEPEND="x11-libs/libX11
	x11-libs/libXext
	!=x11-drivers/nvidia-drivers-180*
	!=x11-drivers/nvidia-drivers-185*
	!=x11-drivers/nvidia-drivers-190.18
	!=x11-drivers/nvidia-drivers-190.25
	!=x11-drivers/nvidia-drivers-190.32
	!=x11-drivers/nvidia-drivers-190.36
	!=x11-drivers/nvidia-drivers-190.40"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=x11-proto/dri2proto-2.2
	doc? (
		app-doc/doxygen
		media-gfx/graphviz
		virtual/latex-base
	)"

DOCS="AUTHORS ChangeLog"

src_prepare() {
	# http://cgit.freedesktop.org/~aplattner/libvdpau/commit/?id=4262513e67c3572ed19bd796ec6180cdde7ccb7e
	epatch "${FILESDIR}"/track_dynamic_library_handles_and_free_them_on_exit.patch

	# http://lists.freedesktop.org/archives/vdpau/2012-May/000022.html
    epatch "${FILESDIR}"/libvdpau_flashplayer.patch

	./autogen.sh
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-dependency-tracking \
		$(use_enable doc documentation) \
		--with-module-dir="${EPREFIX}/usr/$(get_libdir)/vdpau"
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f '{}' +
}
