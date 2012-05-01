# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/zim/zim-0.54.ebuild,v 1.2 2012/04/13 19:51:48 ulm Exp $

EAPI=3

PYTHON_USE_WITH="sqlite"
PYTHON_DEPEND="2:2.5"

inherit distutils eutils fdo-mime virtualx

DESCRIPTION="A desktop wiki"
HOMEPAGE="http://zim-wiki.org/"
SRC_URI="http://zim-wiki.org/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="|| ( >=dev-lang/python-2.6 dev-python/simplejson )
	dev-python/pygtk"
DEPEND="${RDEPEND}
	x11-misc/xdg-utils
	test? ( dev-vcs/bzr )"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	sed -i -e "s/'USER'/'LOGNAME'/g" zim/__init__.py zim/fs.py || die
}

src_test() {
	VIRTUALX_COMMAND="$(PYTHON)" virtualmake test.py || die
}

src_install () {
	doicon data/${PN}.png || die "doicon failed"
	distutils_src_install --skip-xdg-cmd
}

pkg_postinst() {
	distutils_pkg_postinst
	fdo-mime_desktop_database_update
	xdg-icon-resource install --context mimetypes --size 64 \
		"${ROOT}/usr/share/pixmaps/zim.png" \
		application-x-zim-notebook || die "xdg-icon-resource install failed"
	ewarn "Please emerge these packages for additional functionality"
	ewarn "    dev-lang/R"
	ewarn "    dev-python/gtkspell-python"
	ewarn "    dev-vcs/bzr"
	ewarn "    media-gfx/graphviz"
	ewarn "    media-gfx/imagemagick"
	ewarn "    media-gfx/scrot"
	ewarn "    sci-visualization/gnuplot"
	ewarn "    virtual/latex-base app-text/dvipng"
}

pkg_postrm() {
	distutils_pkg_postrm
	fdo-mime_desktop_database_update
	xdg-icon-resource uninstall --context mimetypes --size 64 \
		application-x-zim-notebook || die "xdg-icon-resource uninstall failed"
}
