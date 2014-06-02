# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit git-2 distutils-r1

DESCRIPTION="Mail nagger for gnome-shell (port of popper for unity)"
HOMEPAGE="http://launchpad.net/mailnag"
SRC_URI=""

EGIT_REPO_URI="http://github.com/pulb/mailnag.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="${PYTHON_DEPS}
	sys-devel/gettext"
RDEPEND="${DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/gnome-keyring-python
	gnome-base/libgnome-keyring[introspection]
	media-libs/gstreamer[introspection]
	x11-libs/libnotify[introspection]"

DOCS=( README.md NEWS )

python_install() {
	distutils-r1_python_install
	doman data/mailnag-config.1
	doman data/mailnagd.1
}
