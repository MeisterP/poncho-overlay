# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils gnome2-utils python-single-r1

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

LANGS="ca de el es eu fr gl he it lt pl pt pt_BR ru sv tr vi zh_CN"

for lang in ${LANGS} ; do
	IUSE+=" linguas_${lang}"
done

DEPEND="${PYTHON_DEPS}
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	sys-devel/gettext"

RDEPEND="${DEPEND}
	dev-python/humblewx[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]"

src_prepare(){
	epatch "${FILESDIR}/timeline-1.6.0-path.patch"
}

src_install() {
	python_domodule source/timelinelib
	python_newscript source/timeline.py ${PN}

	insinto /usr/share/${PN}/icons
	doins icons/*.png

	for ling in "${LINGUAS}";do
		if [[ ! -z ${ling} ]] && [[ -d po/"${ling}" ]]; then
			insinto /usr/share/${PN}/translations
			doins translations/"${ling}".po
		fi
	done

	for size in 16 32 48; do
		newicon -s $size icons/$size.png ${PN}.png
	done

	make_desktop_entry ${PN} Timeline ${PN} Graphics

	dodoc AUTHORS README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	optfeature "iCalendar files support" dev-python/icalendar
	optfeature "the builtin documentation" dev-python/markdown
	optfeature "export to svg support" dev-python/pysvg
}

pkg_postrm() {
	gnome2_icon_cache_update
}
