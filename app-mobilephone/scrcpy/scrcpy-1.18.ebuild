# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson optfeature

KEYWORDS="~amd64 ~x86"

SRC_URI="https://github.com/Genymobile/scrcpy/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/scrcpy/releases/download/v${PV}/scrcpy-server-v${PV}"

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND="media-libs/libsdl2[X]
	media-video/ffmpeg"
RDEPEND="${DEPEND}
	dev-util/android-tools"
PDEPEND=""

src_configure() {
	local emesonargs=(
		-Dcompile_app=true
		-Dcompile_server=true
		-Dprebuilt_server="${DISTDIR}/scrcpy-server-v${PV}"
	)
	meson_src_configure
}

pkg_postinst() {
	optfeature "device screen capture as a webcam" media-video/v4l2loopback
}
