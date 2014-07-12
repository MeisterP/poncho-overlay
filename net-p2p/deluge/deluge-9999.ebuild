# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7} )
DISTUTILS_SINGLE_IMPL=1

inherit readme.gentoo distutils-r1 systemd git-r3

EGIT_BRANCH="develop"
EGIT_REPO_URI="git://deluge-torrent.org/${PN}.git
	http://git.deluge-torrent.org/${PN}/"

DESCRIPTION="BitTorrent client with a client/server model."
HOMEPAGE="http://deluge-torrent.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="geoip gtk libnotify setproctitle sound webinterface"

DEPEND="${PYTHON_DEPS}
	>=net-libs/rb_libtorrent-0.14.9[python]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-util/intltool"
RDEPEND="${DEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-8.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-8.1[${PYTHON_USEDEP}]
	geoip? ( dev-libs/geoip )
	gtk? (
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
		gnome-base/librsvg
		libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
	)
	setproctitle? ( dev-python/setproctitle[${PYTHON_USEDEP}] )
	webinterface? ( dev-python/mako[${PYTHON_USEDEP}] )"

DOC_CONTENTS="If it doesn't work after upgrading, please remove the
	'~/.config/deluge' directory and try again, but make a backup
	first!
	To start the daemon either run 'deluged' as user
	or modify /etc/conf.d/deluged and run
	/etc/init.d/deluged start as root.
	For more information look at http://dev.deluge-torrent.org/wiki/Faq"

python_prepare_all() {
	distutils-r1_python_prepare_all
	python_fix_shebang .
}

distutils-r1_python_compile() {
	esetup.py build
}

python_install_all() {
	distutils-r1_python_install_all
	readme.gentoo_create_doc
	newinitd "${FILESDIR}"/deluged.init deluged
	newconfd "${FILESDIR}"/deluged.conf deluged
	systemd_dounit "${FILESDIR}"/deluged.service
	systemd_dounit "${FILESDIR}"/deluge-web.service
}

pkg_postinst() {
	readme.gentoo_print_elog
}
