# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev

MY_PN="libwebcam"

DESCRIPTION="Manage dynamic controls in uvcvideo"
HOMEPAGE="https://sourceforge.net/projects/libwebcam/"
SRC_URI="https://downloads.sourceforge.net/project/libwebcam/source/${MY_PN}-src-${PV}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="dev-libs/libxml2:*"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-nocompress.patch" )

src_install() {
	cmake_src_install
	use static-libs || rm -fr "${D}"/usr/lib*/${MY_PN}.a
	rm -f "${D}"/usr/share/uvcdynctrl/data/046d/logitech.xml~
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
