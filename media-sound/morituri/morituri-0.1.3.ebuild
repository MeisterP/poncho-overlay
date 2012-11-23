# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.6"

inherit bash-completion-r1 

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alac bash-completion +cddb +cdio +flac wav wavpack"

RDEPEND="media-sound/cdparanoia
	app-cdr/cdrdao
	media-libs/gstreamer
	alac? ( media-plugins/gst-plugins-ffmpeg )
	flac? ( media-plugins/gst-plugins-flac )
	wav? ( media-libs/gst-plugins-good )
	wavpack? ( media-plugins/gst-plugins-wavpack )
	dev-python/gst-python
	dev-python/python-musicbrainz
	cddb? ( dev-python/cddb-py )
	dev-python/pygobject
	dev-python/pygtk
	cdio? ( dev-python/pycdio )"
DEPEND="${RDEPEND}"

src_configure() {
	# disable doc building
	local ac_cv_prog_EPYDOC=""

	# disable test
	local ac_cv_prog_PYCHECKER=""

	default
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${D}/etc" || die

	dodoc AUTHORS HACKING NEWS README RELEASE TODO
	use bash-completion && dobashcomp etc/bash_completion.d/rip
}
