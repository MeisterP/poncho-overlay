# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils qt4-r2

DESCRIPTION="Rockbox opensource firmware manager for mp3 players"
HOMEPAGE="http://www.rockbox.org/wiki/RockboxUtility"
SRC_URI="http://download.rockbox.org/${PN}/source/RockboxUtility-v${PV}-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/speex
	x11-libs/qt-core:4
	x11-libs/qt-gui:4
	virtual/libusb:0"
DEPEND="${RDEPEND}"

S=${WORKDIR}/RockboxUtility-v${PV}/${PN}/${PN}qt

src_prepare() {
	epatch "${FILESDIR}"/${P}-accessibility.patch
}

src_configure() {
	# generate binary translations
	lrelease ${PN}qt.pro || die

	# noccache is required in order to call the correct compiler
	eqmake4 CONFIG+=noccache
}

src_install() {
	newbin RockboxUtility ${PN}
	newicon icons/rockbox-256.png ${PN}.png
	make_desktop_entry ${PN} "Rockbox Utility"
}
