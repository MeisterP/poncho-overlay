# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit git-r3 distutils-r1

DESCRIPTION="Unix CD ripper preferring accuracy over speed"
HOMEPAGE="https://github.com/JoeLametta/whipper"
EGIT_REPO_URI="https://github.com/JoeLametta/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}
	dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	app-cdr/cdrdao
	dev-libs/libcdio-paranoia
	dev-python/cddb-py[${PYTHON_USEDEP}]
	dev-python/pycdio[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/flac
	media-libs/libsndfile
	media-libs/mutagen[${PYTHON_USEDEP}]
	media-sound/sox"

PATCHES=( "${FILESDIR}/libcdio-gentoo.patch" )

src_compile() {
	distutils-r1_src_compile
	pushd src
		emake
	popd
}

src_install() {
	distutils-r1_src_install
	pushd src
		emake PREFIX="${D}/usr" install
	popd
}
