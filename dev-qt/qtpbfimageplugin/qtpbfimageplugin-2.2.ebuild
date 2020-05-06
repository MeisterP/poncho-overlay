# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit qmake-utils

#qt5-build
DESCRIPTION="Qt image plugin for displaying Mapbox vector tiles"
HOMEPAGE="https://github.com/tumic0/QtPBFImagePlugin"
SRC_URI="https://github.com/tumic0/QtPBFImagePlugin/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/protobuf
	dev-qt/qtcore:5
	dev-qt/qtgui:5
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/QtPBFImagePlugin-${PV}

src_configure() {
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	dodoc README.md
}
