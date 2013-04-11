# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.5"

inherit python eutils scons-utils gnome2-utils

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="calendar doc svg"

LANGS="ca de es fr gl he it lt pl pt pt_BR ru sv tr vi zh_CN"

for lang in ${LANGS} ; do
	IUSE+=" linguas_${lang}"
done

DEPEND="dev-python/wxpython:2.8
	sys-devel/gettext"

RDEPEND="${DEPEND}
	calendar? ( dev-python/icalendar )
	doc? ( dev-python/markdown )
	svg? ( dev-python/pysvg )"

src_prepare(){
	sed -i "s|\(_ROOT = \).*|\1\"/usr/share/${PN}\"|" timelinelib/config/paths.py || die "sed failed"
}

src_compile() {
	escons mo
}

src_install() {
	insinto $(python_get_sitedir)
	doins -r timelinelib
	doins timeline.py

	insinto /usr/share/${PN}/icons
	doins icons/*.png

	for ling in "${LINGUAS}";do
		if [[ -d po/"${ling}" ]] && [[ ! -z ${ling} ]]; then
			insinto /usr/share/locale/"${ling}"/LC_MESSAGES
			doins po/"${ling}"/LC_MESSAGES/timeline.mo
		fi
	done

	for size in 16 32 48; do
		newicon -s $size icons/$size.png ${PN}.png
	done

	make_wrapper ${PN} "python timeline.py" $(python_get_sitedir)
	make_desktop_entry ${PN} Timeline ${PN} Graphics

	dodoc AUTHORS CHANGES HACKING README
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
