# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.5"

inherit python eutils

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="calendar doc svg"

DEPEND=">=dev-python/wxpython-2.8.9.2
	dev-util/scons
	sys-devel/gettext"

RDEPEND="${DEPEND}
	calendar? ( >=dev-python/icalendar-2.1 )
	doc? ( >=dev-python/markdown-2.0.3 )
	svg? ( >=dev-python/pysvg-0.2.1 )"

src_prepare(){
	# path fix
	sed -i "s|\(_ROOT = \).*|\1\"/usr/share/${PN}\"|" timelinelib/paths.py || die "sed failed"

	# make locale
	scons mo || die "scons failed"
	rm po/*.po || die "rm *.po failed"
}

src_install() {
	newbin timeline.py timeline

	dodir $(python_get_sitedir)
	insinto $(python_get_sitedir)
	doins -r timelinelib

	dodir /usr/share/${PN}
	insinto /usr/share/${PN}
	doins -r icons
	newicon icons/48.png ${PN}.png

	dodir /usr/share/locale
	insinto /usr/share/locale
	doins -r po/*

	dodoc AUTHORS CHANGES HACKING README

	make_desktop_entry ${PN} Timeline ${PN} Graphics
}
