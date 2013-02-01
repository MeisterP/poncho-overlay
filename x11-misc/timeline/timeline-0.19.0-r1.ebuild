# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )

inherit eutils gnome2-utils python-single-r1 scons-utils

DESCRIPTION="Application for displaying and navigating events on a timeline"
HOMEPAGE="http://thetimelineproj.sourceforge.net/"
SRC_URI="mirror://sourceforge/thetimelineproj/${P}.zip"

LICENSE="GPL-3 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="calendar doc svg"

LANGS="ca de es fr gl he it lt pl pt pt_BR ru sv tr vi zh_CN"

for lang in ${LANGS} ; do
	IUSE+=" linguas_${lang}"
done

DEPEND=">=dev-python/wxpython-2.8.9.2
	sys-devel/gettext"

RDEPEND="${DEPEND}
	calendar? ( >=dev-python/icalendar-2.1 )
	doc? ( >=dev-python/markdown-2.0.3 )
	svg? ( >=dev-python/pysvg-0.2.1 )"

src_prepare(){
	sed -i "s|\(_ROOT = \).*|\1\"/usr/share/${PN}\"|" timelinelib/config/paths.py || die "sed failed"

	# see https://bugs.gentoo.org/show_bug.cgi?id=454640
	mv timeline.py ${PN} || die "rename timeline.py failed"

	escons mo
}

src_install() {
	python_domodule timelinelib
	python_doscript ${PN}

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
