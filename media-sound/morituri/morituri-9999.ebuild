# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT="python2_7"

inherit autotools bash-completion-r1 python-single-r1 git-2

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"

EGIT_REPO_URI="git://github.com/thomasvs/morituri.git"
EGIT_HAS_SUBMODULES=1

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alac cdio +cddb doc +flac test wav wavpack"

DEPEND="${PYTHON_DEPS}
	doc? ( dev-python/epydoc[${PYTHON_USEDEP}]
		dev-python/twisted-conch[${PYTHON_USEDEP}] )
	test? ( dev-python/pychecker
		dev-python/twisted-core[${PYTHON_USEDEP}] )"

RDEPEND="${PYTHON_DEPS}
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

DOCS=( AUTHORS ChangeLog HACKING NEWS README.md TODO )

src_prepare() {
	# fix python shebang
	# see https://bugs.gentoo.org/show_bug.cgi?id=472530#c0
	sed -i '\|unset PYTHON|d' \
        m4/as-python.m4 || die

	# fix completion location
	sed -i "s|^completiondir =.*|completiondir = $(get_bashcompdir)|" \
        etc/bash_completion.d/Makefile.am || die

	# disable failing test
	epatch "${FILESDIR}"/disable-test.patch

	# TODO: make doc and test not automagic

	eautoreconf
}

src_install() {
	default
	use doc && dohtml -r doc/reference/*
}
