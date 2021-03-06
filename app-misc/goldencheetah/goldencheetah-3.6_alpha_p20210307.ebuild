# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit desktop flag-o-matic udev qmake-utils python-single-r1 xdg

MY_COMMIT="3308372445eb998a8bad9305647137475aee74a0"

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="http://goldencheetah.org"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-libs/libical
	dev-qt/qtbluetooth:5
	dev-qt/qtcharts:5
	dev-qt/qtconcurrent:5
	dev-qt/qtpositioning:5
	dev-qt/qtserialport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebengine:5[widgets]
	media-libs/libsamplerate
	media-video/vlc
	sci-libs/gsl
	virtual/libusb:1"
DEPEND="${RDEPEND}
	dev-python/sip
	>=sys-devel/bison-3.7
	sys-devel/flex
	virtual/pkgconfig"

S="${WORKDIR}/GoldenCheetah-${MY_COMMIT}"

PATCHES=(
	# https://github.com/GoldenCheetah/GoldenCheetah/pull/3113
	"${FILESDIR}"/0001-Workout-Only-scale-on-Ctrl-mouse-wheel.patch

	# https://github.com/GoldenCheetah/GoldenCheetah/issues/3586
	"${FILESDIR}"/0001-Fix-building-with-bison-3.7.patch

	"${FILESDIR}"/0001-Add-Shimano-EW-WU111.patch
	)

src_prepare() {
	xdg_src_prepare

	cat <<- EOF > src/gcconfig.pri || die
		CONFIG += release link_pkgconfig
		QMAKE_LRELEASE = $(qt5_get_bindir)/lrelease
		PKGCONFIG = zlib gsl libusb-1.0 samplerate libical libvlc python3-embed

		LIBUSB_INSTALL = true
		LIBUSB_USE_V_1 = true
		SAMPLERATE_INSTALL = true
		ICAL_INSTALL = true
		VLC_INSTALL = true
		DEFINES += GC_WANT_PYTHON
		DEFINES += GC_VIDEO_VLC
		DEFINES += GC_WANT_ROBOT
	EOF

	cp qwt/qwtconfig.pri.in qwt/qwtconfig.pri || die
	sed -i -e "s:/usr/local/:/usr/:" \
		qwt/qwtconfig.pri || die

	sip -c src/Python/SIP src/Python/SIP/goldencheetah.sip || die
}

src_configure() {
	replace-flags -O? -O3
	eqmake5
}

src_install() {
	dobin src/GoldenCheetah
	udev_dorules src/Resources/linux/51-garmin-usb.rules

	doicon src/Resources/images/gc.png
	newmenu - goldencheetah.desktop <<-EOF
		[Desktop Entry]
		Version=1.0
		Type=Application
		Name=GoldenCheetah
		Comment=Cycling Power Analysis Software.
		Exec=GoldenCheetah
		Icon=gc
		Categories=Science;Sports;
	EOF

	dodoc README.md CONTRIBUTING.md
}
