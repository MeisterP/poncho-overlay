# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit fcaps desktop xdg flag-o-matic udev qmake-utils python-single-r1

MY_COMMIT="bf843459c7d497d966a01177ff221c1cc6e49e75"

DESCRIPTION="Performance Software for Cyclists, Runners and Triathletes"
HOMEPAGE="https://www.goldencheetah.org"

SRC_URI="https://github.com/GoldenCheetah/GoldenCheetah/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/GoldenCheetah-${MY_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

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
	dev-qt/qt5compat
	dev-qt/qtbase:6[concurrent,gui,network,opengl,sql,sqlite,widgets,xml]
	dev-qt/qtcharts:6
	dev-qt/qtconnectivity:6[bluetooth]
	dev-qt/qtmultimedia:6
	dev-qt/qtpositioning:6
	dev-qt/qtserialport:6
	dev-qt/qtsvg:6
	dev-qt/qttools:6[linguist]
	dev-qt/qtwebchannel:6
	dev-qt/qtwebengine:6[widgets,qml]
	media-libs/libsamplerate
	media-video/vlc
	sci-libs/gsl:=
	virtual/libusb:1"

RDEPEND="${DEPEND}"

DOCS=( README.md CONTRIBUTING.md )

FILECAPS=( cap_net_admin usr/bin/GoldenCheetah )

src_configure() {
	cat <<- EOF > src/gcconfig.pri || die
		CONFIG += release link_pkgconfig
		QMAKE_LRELEASE = $(qt6_get_bindir)/lrelease
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

	cp -v qwt/qwtconfig.pri.in qwt/qwtconfig.pri || die

	sip -c src/Python/SIP src/Python/SIP/goldencheetah.sip || die

	replace-flags -O? -O3
	eqmake6
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
