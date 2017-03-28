# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils gnome2-utils qmake-utils

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5
	virtual/libusb:1"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.3.1-accessibility.patch )

S=${WORKDIR}/RockboxUtility-v${PV}/${PN}/${PN}qt

src_configure() {
	# generate binary translations
	$(qt5_get_bindir)/lrelease ${PN}qt.pro || die

	# noccache is required in order to call the correct compiler
	eqmake5 CONFIG+=noccache
}

src_install() {
	newbin RockboxUtility ${PN}
	newicon icons/rockbox-256.png ${PN}.png
	make_desktop_entry ${PN} "Rockbox Utility" ${PN} "AudioVideo;Audio;Utility" "StartupWMClass=rbutil"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	optfeature "Text to Speech" app-accessibility/espeak
	optfeature "Voice Interface" media-libs/speex
}

pkg_postrm() {
	gnome2_icon_cache_update
}
