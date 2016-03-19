# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit git-r3 autotools bash-completion-r1 python-single-r1

DESCRIPTION="Unix CD ripper preferring accuracy over speed"
HOMEPAGE="https://github.com/JoeLametta/whipper"
EGIT_REPO_URI="https://github.com/JoeLametta/${PN}.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	dev-python/python-musicbrainz-ngs[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	app-cdr/cdrdao
	dev-python/pycdio[${PYTHON_USEDEP}]
	dev-python/cddb-py[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:0.10[ffmpeg,flac,lame,vorbis,wavpack]
	media-sound/cdparanoia"

src_prepare() {
	eautoreconf
}

src_configure() {
	# disable doc and test
	ac_cv_prog_EPYDOC="" ac_cv_prog_PYCHECKER="" econf
}

src_install() {
	emake DESTDIR="${D}" completiondir="$(get_bashcompdir)" install
	dodoc AUTHORS ChangeLog HACKING NEWS README.md RELEASE TODO
}
