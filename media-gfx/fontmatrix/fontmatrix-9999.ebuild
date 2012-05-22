# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils qt4-r2 cmake-utils subversion

ESVN_REPO_URI="http://svn.gna.org/svn/undertype/trunk/tools/typotek"
#ESVN_REPO_URI="http://svn.gna.org/svn/undertype/trunk/tools/typotek@1073"

DESCRIPTION="A font manager"
HOMEPAGE="http://fontmatrix.be/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

IUSE="debug pdf m17 icu harfbuzz"

RDEPEND="x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-sql:4
	x11-libs/qt-svg:4
	x11-libs/qt-webkit:4
	media-libs/freetype:2
	icu? ( dev-libs/icu )
	m17? ( dev-libs/m17n-lib )
	pdf? ( media-libs/podofo )"
DEPEND=${RPEDEND}

pkg_setup() {
	if ! use harfbuzz; then
		ewarn "- harfbuzz shaping support is internal and"
		ewarn "  generally used by Pango and Qt apps."
	fi
	if ! use icu; then
		ewarn "- icu shaping support is known to be used by"
		ewarn "  Openoffice and Xetex."
	fi
	if ! use pdf; then
		ewarn "- if you want to extract fonts from pdfs"
		ewarn "  get media-libs/podofo from bugzilla, see: "
		ewarn "  https://bugs.gentoo.org/show_bug.cgi?id=140557"
	fi
	if use m17; then
		ewarn "- m17 shaping  support is currently experimental"
		ewarn "  and reported as *NOT WORKING*!"
	fi
}

src_prepare() {
	epatch "${FILESDIR}/bug_564904_fix-missing-DSO-icuuc.patch"
}

src_compile() {
	local mycmakeargs="
		-DWANT_PYTHONQT=1
		$(cmake-utils_use_want harfbuzz HARFBUZZ)
		$(cmake-utils_use_want m17 M17N)
		$(cmake-utils_use_want icu ICU)
		$(cmake-utils_use_want pdf PODOFO)"
		#-DOWN_SHAPER=1
	cmake-utils_src_compile
}

#src_install() {
#	dobin "${CMAKE_BUILD_DIR}"/src/${PN}
#	doman ${PN}.1
#	domenu ${PN}.desktop
#	doicon ${PN}.png
#	dodoc ChangeLog TODO
#}

src_install() {
	domenu ${PN}.desktop
	doicon ${PN}.png
	dodoc ChangeLog TODO
	cmake-utils_src_install
}

pkg_postinst() {
	elog "If you encounter problems or just have questions or if you have"
	elog " suggestions, please take time to suscribe to the undertype-users"
	elog " mailing list ( https://mail.gna.org/listinfo/undertype-users )."
	elog " If you want to reach us quickly, come to #fontmatrix at Freenode."
}
