# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 python-single-r1

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="https://thomas.apestaart.org/morituri/trac/"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	app-cdr/cdrdao
	dev-python/pycdio[${PYTHON_USEDEP}]
	dev-python/cddb-py[${PYTHON_USEDEP}]
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	media-plugins/gst-plugins-meta:0.10[ffmpeg,flac,lame,vorbis,wavpack]
	media-sound/cdparanoia"

src_configure() {
	# disable doc and test
	ac_cv_prog_EPYDOC="" ac_cv_prog_PYCHECKER="" econf
}

src_install() {
	emake DESTDIR="${D}" completiondir="$(get_bashcompdir)" install
	dodoc AUTHORS ChangeLog HACKING NEWS README RELEASE TODO
}
