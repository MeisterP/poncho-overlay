# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit games cmake-utils git-2

EGIT_REPO_URI="git://github.com/vayerx/shadowgrounds.git"
EGIT_BRANCH="linux"

if [[ "${PV}" = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="amd64-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Shadowgrounds Survivor is 3rd-person alien-shooter."
HOMEPAGE="http://github.com/vayerx/shadowgrounds"
SRC_URI=""

LICENSE="shadowgrounds"
GAMES_CHECK_LICENSE="yes"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.42
	media-libs/glew
	media-libs/libsdl[audio,video,joystick,X,opengl]
	media-libs/sdl-sound
	media-libs/sdl-image
	media-libs/sdl-ttf
	virtual/opengl
	x11-libs/gtk+
	sys-libs/zlib
	media-libs/openal
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_configure() {
	mycmakeargs+=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DICON_DIR=/usr/share/pixmaps"
		"-DDESKTOP_DIR=/usr/share/applications"
		"-DCMAKE_DATA_PATH=${GAMES_DATADIR}"
		"-DCMAKE_CONF_PATH=${GAMES_SYSCONFDIR}"
		"-DINSTALLONLY=${PN}"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make survivor
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	ewarn "You will need data files to run the game."
	ewarn "Consider installing games-action/survivor-data"
	ewarn "or copying files manually to /usr/share/games/${PN}"
}
