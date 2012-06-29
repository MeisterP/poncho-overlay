# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.5"

inherit python eutils scons-utils

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="calendar doc svg"

LANGS="ca de es fr gl he it lt pl pt ru sv tr vi pt_BR"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

DEPEND=">=dev-python/wxpython-2.8.9.2
	sys-devel/gettext"

RDEPEND="${DEPEND}
	calendar? ( >=dev-python/icalendar-2.1 )
	doc? ( >=dev-python/markdown-2.0.3 )
	svg? ( >=dev-python/pysvg-0.2.1 )"

src_prepare(){
	# path fix
	sed -i "s|\(_ROOT = \).*|\1\"/usr/share/${PN}\"|" timelinelib/config/paths.py || die "sed failed"

	escons mo
}

src_install() {
	newbin timeline.py timeline

	dodir $(python_get_sitedir)
	insinto $(python_get_sitedir)
	doins -r timelinelib

	insinto /usr/share/${PN}/icons
	doins icons/*.png

	for size in 16 32 48; do
		newicon -s $size icons/$size.png ${PN}.png
	done

	insinto /usr/share/locale
	for x in "${LINGUAS}";do
		if [[ -d po/"${x}" ]];then
			doins -r po/"${x}"
		else
			einfo "LANGUAGE $x is not supported"
		fi
	done

	dodoc AUTHORS CHANGES HACKING README

	make_desktop_entry ${PN} Timeline ${PN} Graphics
}
