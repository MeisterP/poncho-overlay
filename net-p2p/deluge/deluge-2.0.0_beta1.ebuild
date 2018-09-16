# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1
PLOCALES="af ar ast be bg bn bs ca cs cy da de el en_AU en_CA en_GB eo es et eu fa fi fo fr fy ga gl he hi hr hu id is it iu ja ka kk km kn ko ku ky la lb lt lv mk ml ms nap nb nds nl nn oc pl pms pt pt_BR ro ru si sk sl sr sv ta te th tl tlh tr uk ur vi zh_CN zh_HK zh_TW"
inherit git-r3 distutils-r1 eutils xdg-utils gnome2-utils systemd user l10n

MY_PV="2.0.0b1"

DESCRIPTION="BitTorrent client with a client/server model"
HOMEPAGE="https://deluge-torrent.org/"
EGIT_REPO_URI="https://github.com/deluge-torrent/deluge.git"
EGIT_COMMIT="deluge-${MY_PV}"
EGIT_CLONE_TYPE="shallow"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="console geoip gtk libnotify sound webinterface"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	sound? ( gtk )
	libnotify? ( gtk )
"

CDEPEND=">=net-libs/libtorrent-rasterbar-0.14.9[python,${PYTHON_USEDEP}]"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-util/intltool"
RDEPEND="${CDEPEND}
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	|| ( >=dev-python/twisted-16.0.0[${PYTHON_USEDEP}]
		>=dev-python/twisted-web-13.0[${PYTHON_USEDEP}]
	)
	geoip? ( dev-libs/geoip )
	gtk? (
		sound? ( dev-python/pygame[${PYTHON_USEDEP}] )
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		>=dev-python/pygtk-2.12[${PYTHON_USEDEP}]
		gnome-base/librsvg
		libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
	)
	webinterface? ( dev-python/mako[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -i "/('build_webui', None),/d" setup.py || die
	distutils-r1_python_prepare_all
}

esetup.py() {
	# bug 531370: deluge has its own plugin system. No need to relocate its egg info files.
	# Override this call from the distutils-r1 eclass.
	# This does not respect the distutils-r1 API. DONOT copy this example.
	set -- "${PYTHON}" setup.py "$@"
	echo "$@"
	"$@" || die
}

python_install_all() {
	distutils-r1_python_install_all
	if ! use console ; then
		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/console/" || die
		rm -f "${D}/usr/bin/deluge-console" || die
		rm -f "${D}/usr/share/man/man1/deluge-console.1" ||die
	fi
	if ! use gtk ; then
		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/gtkui/" || die
		rm -rf "${D}/usr/share/icons/" || die
		rm -f "${D}/usr/bin/deluge-gtk" || die
		rm -f "${D}/usr/share/man/man1/deluge-gtk.1" || die
		rm -f "${D}/usr/share/applications/deluge.desktop" || die
	fi
#	if use webinterface; then
#		systemd_dounit packaging/systemd/deluge-web.service.service
#	else
#		rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/web/" || die
#		rm -f "${D}/usr/bin/deluge-web" || die
#		rm -f "${D}/usr/share/man/man1/deluge-web.1" || die
#	fi
	rm -rf "${D}/usr/$(get_libdir)/python2.7/site-packages/deluge/ui/web/" || die
	rm -f "${D}/usr/bin/deluge-web" || die
	rm -f "${D}/usr/share/man/man1/deluge-web.1" || die
	systemd_dounit packaging/systemd/deluged.service
}

pkg_postinst() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}
}

pkg_postrm() {
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
