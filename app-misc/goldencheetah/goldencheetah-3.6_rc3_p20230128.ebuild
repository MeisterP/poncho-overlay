# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )

inherit fcaps desktop xdg flag-o-matic udev qmake-utils python-single-r1

MY_COMMIT="11decfc508b510ec73d4c898d091ef0ccb98662a"

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="https://www.goldencheetah.org"
SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/sip:0[${PYTHON_USEDEP}]
	')
	>=sys-devel/bison-3.7
	sys-devel/flex
	virtual/pkgconfig"

DEPEND="${PYTHON_DEPS}
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
	sci-libs/gsl:=
	virtual/libusb:1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/GoldenCheetah-${MY_COMMIT}"

DOCS=( README.md CONTRIBUTING.md )

FILECAPS=( cap_net_admin usr/bin/GoldenCheetah )

src_configure() {
	cat <<- EOF > src/gcconfig.pri || die
		CONFIG += release link_pkgconfig
		QMAKE_LRELEASE = $(qt5_get_bindir)/lrelease
		QMAKE_MOVE = cp
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

	sed -e "s:/usr/local/:/usr/:" qwt/qwtconfig.pri.in > qwt/qwtconfig.pri || die

	sip -c src/Python/SIP src/Python/SIP/goldencheetah.sip || die

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

	einstalldocs
}

pkg_postinst() {
	fcaps_pkg_postinst
	xdg_pkg_postinst
	udev_reload
}

pkg_postrm() {
	xdg_pkg_postrm
	udev_reload
}
