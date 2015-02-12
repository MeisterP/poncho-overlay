# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit gnome2-utils distutils-r1

DESCRIPTION="Mail nagger for gnome-shell (port of popper for unity)"
HOMEPAGE="http://launchpad.net/mailnag"
SRC_URI="https://github.com/pulb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	sys-devel/gettext"
RDEPEND="${DEPEND}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/gnome-keyring-python
	media-libs/gstreamer[introspection]
	x11-libs/gdk-pixbuf[introspection]
	x11-libs/libnotify[introspection]"

python_install() {
	distutils-r1_python_install
	doman data/mailnag.1
	doman data/mailnag-config.1
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
