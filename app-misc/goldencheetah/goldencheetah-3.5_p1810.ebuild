# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils udev qmake-utils

MY_PV=${PV/_p/-DEV}

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="http://goldencheetah.org"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-qt/qtbluetooth:5
	dev-qt/qtcharts:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtserialport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	virtual/libusb:1"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/GoldenCheetah-${MY_PV}"

src_prepare() {
	default

	cat <<- EOF > src/gcconfig.pri || die
		CONFIG += release
		QMAKE_CXXFLAGS += -O3
		QMAKE_LRELEASE = $(qt5_get_bindir)/lrelease

		LIBZ_LIBS = -lz

		LIBUSB_INSTALL = /usr
		LIBUSB_LIBS = -lusb

		#DEFINES += NOWEBKIT
		DEFINES += GC_VIDEO_QT5
		DEFINES += GC_WANT_ROBOT
	EOF

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
	make_desktop_entry GoldenCheetah GoldenCheetah gc Science StartupWMClass=GoldenCheetah

	dodoc README.md
}
