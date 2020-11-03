# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils
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
	cmake-utils_src_install
	rm -fr "${D}"usr/lib*/${MY_PN}.a || die
}
