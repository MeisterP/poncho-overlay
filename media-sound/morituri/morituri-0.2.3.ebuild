# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT="python2_7"

inherit bash-completion-r1 python-single-r1

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alac cdio +cddb +flac wav wavpack"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	media-sound/cdparanoia
	app-cdr/cdrdao
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	alac? ( media-plugins/gst-plugins-ffmpeg:0.10 )
	cdio? ( dev-python/pycdio )
	cddb? ( dev-python/cddb-py )
	flac? ( media-plugins/gst-plugins-flac:0.10 )
	wav? ( media-libs/gst-plugins-good:0.10 )
	wavpack? ( media-plugins/gst-plugins-wavpack:0.10 )
	dev-python/gst-python:0.10[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"

src_install() {
	emake DESTDIR="${D}" completiondir="$(get_bashcompdir)" install
	dodoc AUTHORS ChangeLog HACKING NEWS README RELEASE TODO
}
