# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT="python2_7"

inherit eutils bash-completion-r1 python-single-r1

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alac cdio +cddb +flac wav wavpack"

RDEPEND="media-sound/cdparanoia
	app-cdr/cdrdao
	media-libs/gstreamer
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
DEPEND="dev-vcs/git
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/shebang-fix.patch
}

src_configure() {
	# https://github.com/thomasvs/morituri/issues/40
	export GIT_DISCOVERY_ACROSS_FILESYSTEM=1

	# disable doc building
	local ac_cv_prog_EPYDOC=""

	# disable test
	local ac_cv_prog_PYCHECKER=""

	default
}

src_install() {
	default

	python_doscript bin/rip

	rm -rf "${D}/etc" || die
	dobashcomp etc/bash_completion.d/rip

	dodoc AUTHORS HACKING NEWS README RELEASE TODO
}