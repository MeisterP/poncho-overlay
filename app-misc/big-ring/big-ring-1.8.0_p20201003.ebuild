# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils xdg

MY_COMMIT="aa672908f7a30fefa5e42e8c3167175d8b6d0d3c"

DESCRIPTION="Engaging virtual cycling experience"
HOMEPAGE="https://github.com/MeisterP/big-ring/tree/develop"
SRC_URI="https://github.com/MeisterP/big-ring/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtopengl:5
	dev-qt/qtserialport:5
	dev-qt/qtwidgets:5
	media-video/ffmpeg
	virtual/libusb:1
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/big-ring-${MY_COMMIT}"

src_configure() {
	eqmake5
}

src_test() {
	test/tests
}

src_install() {
	dobin bin/{anttestapp,big-ring}

	doicon mainlib/BigRingIcon.png
	newmenu - big-ring.desktop <<-EOF
		[Desktop Entry]
		Version=1.0
		Type=Application
		Name=Big Ring Indoor Video Cycling
		Comment=Engaging virtual cycling experience
		Exec=big-ring
		Icon=BigRingIcon
		Categories=AudioVideo;Sports;
	EOF

	dodoc "${FILESDIR}"/51-garmin-usb.rules CHANGELOG.md README.md
}
