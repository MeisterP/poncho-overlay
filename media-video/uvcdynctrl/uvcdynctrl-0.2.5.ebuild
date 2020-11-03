# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake
MY_PN="libwebcam"
MY_P="${MY_PN}-src-${PV}"

HOMEPAGE="https://sourceforge.net/projects/libwebcam/"
DESCRIPTION="Manage dynamic controls in uvcvideo"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"
IUSE=""

DEPEND="dev-libs/libxml2"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	cmake_src_install
	rm -v "${D}"/usr/lib*/${MY_PN}.a || die
	rm -v "${D}"/usr/share/uvcdynctrl/data/046d/logitech.xml~

	rm -v "${D}"/usr/share/man/man1/*.gz || die
	newman "${WORKDIR}"/libwebcam-${PV}/uvcdynctrl/uvcdynctrl.1_ uvcdynctrl.1
}
