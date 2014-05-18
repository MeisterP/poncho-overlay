# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT="python2_7"

inherit autotools bash-completion-r1 python-single-r1

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
	media-libs/gstreamer
	media-libs/gst-plugins-base
	alac? ( media-plugins/gst-plugins-ffmpeg )
	cdio? ( dev-python/pycdio )
	cddb? ( dev-python/cddb-py )
	flac? ( media-plugins/gst-plugins-flac )
	wav? ( media-libs/gst-plugins-good )
	wavpack? ( media-plugins/gst-plugins-wavpack )
	dev-python/gst-python[${PYTHON_USEDEP}]
	dev-python/python-musicbrainz[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]"

DOCS=( AUTHORS ChangeLog HACKING NEWS README TODO )

src_prepare() {
	# https://github.com/thomasvs/morituri/pull/78
	epatch "${FILESDIR}"/209b7d6621eb652a230f0ba5c4c359a4c2a39ed2.patch

	# fix completion location
	sed -i "s|^completiondir =.*|completiondir = $(get_bashcompdir)|" \
        etc/bash_completion.d/Makefile.am || die

	# https://github.com/thomasvs/morituri/issues/40
	epatch "${FILESDIR}"/df0daefa27f6911167c73424ccac1c3d9480abf2.patch

	eautoreconf
}
