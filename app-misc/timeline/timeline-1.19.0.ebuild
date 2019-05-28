# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PLOCALES="ca de el es eu fr gl he it ko lt nl pl pt pt_BR ru sv tr vi zh_CN"

inherit desktop xdg-utils l10n python-single-r1

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/wxpython:3.0[${PYTHON_USEDEP}]
	sys-devel/gettext"

RDEPEND="${DEPEND}
	dev-python/humblewx[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}/timeline-1.10.0-path.patch" )

src_prepare() {
	default
	l10n_find_plocales_changes "${S}/translations" "" ".po"
}

src_install() {
	python_domodule source/timelinelib
	python_newscript source/timeline.py ${PN}

	insinto /usr/share/${PN}/icons
	doins -r icons/{*.png,*.bmp,event_icons}

	insinto /usr/share/${PN}/translations
	for lang in $(l10n_get_locales); do
		doins translations/${lang}.po
	done

	for size in 16 32 48; do
		newicon -s $size icons/$size.png ${PN}.png
	done

	make_desktop_entry ${PN} Timeline ${PN} Graphics

	dodoc AUTHORS README
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update

	if ! has_version ${CATEGORY}/${PN}; then
		elog "Please install these packages for additional functionality"
		elog "    dev-python/icalendar  iCalendar file support"
		elog "    dev-python/markdown   view the builtin documentation"
		elog "    dev-python/pysvg      export to svg"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
}
