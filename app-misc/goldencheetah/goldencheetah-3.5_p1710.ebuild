# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils udev qmake-utils

MY_PV="3.5-DEV1710"

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="http://goldencheetah.org"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtbluetooth:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtserialport:5
	dev-qt/qtsvg:5
	dev-qt/qttranslations:5
	dev-qt/qtwebkit:5
	x11-libs/qwt[qt5]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/GoldenCheetah-${MY_PV}"

src_prepare() {
	eapply_user

	cp src/gcconfig.pri.in src/gcconfig.pri ||die
	sed -i -e "s:#CONFIG += release:CONFIG += release:" \
		-e "s:#QMAKE_LRELEASE = /usr/bin/lrelease:QMAKE_LRELEASE = "$(qt5_get_bindir)"/lrelease:" \
		-e "s:#LIBZ_LIBS    = -lz:LIBZ_LIBS = -lz:" \
		src/gcconfig.pri || die

	cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri || die
	sed -i -e "s:/usr/local/:/usr/:" \
		qwt/qwtconfig.pri || die
}

src_configure() {
	eqmake5
}

src_install() {
	dobin src/GoldenCheetah
	udev_dorules src/Resources/linux/51-garmin-usb.rules

	doicon src/Resources/images/gc.png
	make_desktop_entry GoldenCheetah GoldenCheetah gc Science

	dodoc README.md
}
