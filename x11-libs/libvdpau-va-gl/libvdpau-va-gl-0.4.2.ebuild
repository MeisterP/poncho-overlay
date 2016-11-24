# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="VDPAU driver with OpenGL/VAAPI backend"
HOMEPAGE="https://github.com/i-rinat/libvdpau-va-gl"
SRC_URI="https://github.com/i-rinat/${PN}/releases/download/v${PV}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="MIT"
SLOT="0"

RDEPEND="media-libs/mesa
		x11-base/xorg-server
		x11-libs/libvdpau
		x11-libs/libva"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install() {
	cmake-utils_src_install
	echo 'VDPAU_DRIVER=va_gl' > 61libvdpau-va-gl
	doenvd 61libvdpau-va-gl
}
