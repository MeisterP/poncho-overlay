# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
PLOCALES="ca de el es eu fr gl he it ko lt nl pl pt pt_BR ru sv tr vi zh_CN"

inherit desktop plocale xdg python-single-r1

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="https://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/wxpython:4.0[${PYTHON_USEDEP}]
	')
	sys-devel/gettext"

RDEPEND="${DEPEND}
	$(python_gen_cond_dep '
		dev-python/humblewx[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	')"

BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}/timeline-2.0.0-path.patch" )

src_prepare() {
	default
	plocale_find_changes "${S}/translations" "" ".po"
}

src_install() {
	python_domodule source/timelinelib
	python_newscript source/timeline.py ${PN}

	insinto /usr/share/${PN}/icons
	doins -r icons/{*.png,*.ico,event_icons}

	insinto /usr/share/${PN}/translations
	for lang in $(plocale_get_locales); do
		doins translations/${lang}.po
	done

	for size in 16 32 48; do
		newicon -s $size icons/$size.png ${PN}.png
	done

	make_desktop_entry ${PN} Timeline ${PN} Graphics

	dodoc AUTHORS README documentation/changelog.rst
}

pkg_postinst() {
	xdg_pkg_postinst

	if ! has_version ${CATEGORY}/${PN}; then
		elog "Please install these packages for additional functionality"
		elog "    dev-python/icalendar  iCalendar file support"
		elog "    dev-python/markdown   view the builtin documentation"
	fi
}
