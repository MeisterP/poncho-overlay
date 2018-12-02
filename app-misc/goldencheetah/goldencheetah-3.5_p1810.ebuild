# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6,7} )

inherit eutils flag-o-matic udev qmake-utils python-single-r1

MY_PV=${PV/_p/-DEV}

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="http://goldencheetah.org"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	dev-qt/qtbluetooth:5
	dev-qt/qtcharts:5
	dev-qt/qtconcurrent:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtpositioning:5
	dev-qt/qtserialport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	virtual/libusb:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/GoldenCheetah-${MY_PV}"

PATCHES=("${FILESDIR}/0001-Remove-google.api-for-openstreetmap-mode-1-4.patch"
	"${FILESDIR}/0002-RideMapWindow-Use-leaflet-instead-of-googlemap-api-f.patch"
	"${FILESDIR}/0003-RideMap-3-4-draw-interval-on-OSM.patch"
	"${FILESDIR}/0004-Only-try-and-build-CalDAVCloud-if-ical-is-present.patch"
	"${FILESDIR}/0005-Changed-Notes-to-Calendar-Text-in-LTMPopup.patch" )

src_prepare() {
	default

	cat <<- EOF > src/gcconfig.pri || die
		CONFIG += release link_pkgconfig
		QMAKE_LRELEASE = $(qt5_get_bindir)/lrelease
		PKGCONFIG = zlib libusb python3

		LIBUSB_INSTALL = /usr
		DEFINES += GC_WANT_PYTHON GC_WANT_ROBOT
		DEFINES += NOWEBKIT GC_VIDEO_QT5
	EOF

	cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri || die
	sed -i -e "s:/usr/local/:/usr/:" \
		qwt/qwtconfig.pri || die
}

src_configure() {
	replace-flags -O? -O3
	eqmake5
}

src_install() {
	dobin src/GoldenCheetah
	udev_dorules src/Resources/linux/51-garmin-usb.rules

	doicon src/Resources/images/gc.png
	make_desktop_entry GoldenCheetah GoldenCheetah gc Science StartupWMClass=GoldenCheetah

	dodoc README.md
}
