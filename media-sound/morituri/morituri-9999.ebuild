# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.6"

inherit bash-completion-r1 git-2 python subversion

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"

#SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"
ESVN_REPO_URI="http://thomas.apestaart.org/morituri/svn/trunk"
ESVN_BOOTSTRAP="autogen.sh"
EGIT_REPO_URI="https://github.com/thomasvs/python-musicbrainz-ngs.git"
EGIT_SOURCEDIR="${S}/${PN}/extern/python-musicbrainz-ngs"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE="alac bash-completion +cddb +cdio doc +flac test wav wavpack"

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
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )
	test? ( dev-python/pychecker )"

src_unpack() {
    subversion_src_unpack
    git-2_src_unpack
}

src_prepare() {
    subversion_src_prepare 

	use doc && die "doc building currently broken"
}

src_configure() {
	# disable doc building, we do it manually
	export ac_cv_prog_EPYDOC=""
	default
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}/etc"

	dodoc AUTHORS HACKING NEWS README RELEASE TODO
	use bash-completion && dobashcomp etc/bash_completion.d/rip

	use doc && dohtml -r doc/reference/*
}
