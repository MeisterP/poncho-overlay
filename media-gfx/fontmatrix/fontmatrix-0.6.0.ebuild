# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit qt4-r2 cmake-utils

DESCRIPTION="A font manager"
HOMEPAGE="http://www.fontmatrix.net/"
SRC_URI="http://www.fontmatrix.net/archives/${P}-Source.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-sql:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4
	media-libs/freetype:2"
DEPEND=${RPEDEND}

S=${WORKDIR}/${P}-Source

src_configure() {
	local mycmakeargs="-DOWN_SHAPER=1"
	cmake-utils_src_configure
}

src_install() {
	dobin "${CMAKE_BUILD_DIR}"/src/${PN}
	doman ${PN}.1
	domenu ${PN}.desktop
	doicon ${PN}.png
	dodoc ChangeLog TODO
}

pkg_postinst() {
	elog "If you encounter problems or just have questions or if you have"
	elog " suggestions, please take time to suscribe to the undertype-users"
	elog " mailing list ( https://mail.gna.org/listinfo/undertype-users )."
	elog " If you want to reach us quickly, come to #fontmatrix at Freenode."
}
