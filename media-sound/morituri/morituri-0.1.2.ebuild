# Copyright 1999-2012 Tiziano Mueller
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit bash-completion-r1 distutils

DESCRIPTION="CD ripper aiming for accuracy over speed."
HOMEPAGE="http://thomas.apestaart.org/morituri/trac/wiki"
SRC_URI="http://thomas.apestaart.org/download/morituri/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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

src_prepare() {
	ln -sf "$(type -P true)" py-compile

	use doc && die "doc building currently broken"
}

src_configure() {
	# disable doc building, we do it manually
	export ac_cv_prog_EPYDOC=""
	default
}

src_compile() {
	default

	if use doc ; then
		cd doc
		epydoc -o reference ../morituri || die "generating docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	rm -rf "${D}/etc"

	dodoc AUTHORS HACKING NEWS README RELEASE TODO
	use bash-completion && dobashcomp etc/bash_completion.d/rip

	use doc && dohtml -r doc/reference/*
}

pkg_postinst()
{
	return
}

pkg_postrm()
{
	return
}
