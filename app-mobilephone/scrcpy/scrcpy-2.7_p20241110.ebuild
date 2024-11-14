# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

# glfilter branch
MY_COMMIT="bf23866115a0f6cb0552e1da34e23a7e23f29069"

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"

SRC_URI="https://github.com/Genymobile/scrcpy/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/libsdl2[X]
	media-video/ffmpeg:=
	virtual/libusb:1
"
# Manual install for ppc64 until bug #723528 is fixed
RDEPEND="
	${DEPEND}
	!ppc64? ( dev-util/android-tools )
"

src_configure() {
	local emesonargs=(
		-Dprebuilt_server="${FILESDIR}/scrcpy-server"
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postrm

	einfo "If you use pipewire because of a problem with libsdl2 it is possible that"
	einfo "scrcpy will not start, in which case start the program by exporting the"
	einfo "environment variable SDL_AUDIODRIVER=pipewire."
	einfo "For more information see https://github.com/Genymobile/scrcpy/issues/3864."
}
