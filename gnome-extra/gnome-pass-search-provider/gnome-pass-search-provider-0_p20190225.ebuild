# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} )

inherit desktop gnome2-utils systemd python-single-r1

COMMIT="45cea53ef4f25fb8a0b905587cc5be816668c3a0"

DESCRIPTION="Pass password manager search provider for gnome-shell"
HOMEPAGE="https://github.com/jle64/gnome-pass-search-provider"
SRC_URI="https://github.com/jle64/gnome-pass-search-provider/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	app-admin/pass[X]
	dev-python/fuzzywuzzy[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]"

S=${WORKDIR}/${PN}-${COMMIT}

src_install() {
	python_scriptinto /usr/lib/gnome-pass-search-provider
	python_doscript gnome-pass-search-provider.py

	insinto /usr/share/gnome-shell/search-providers
	doins conf/org.gnome.Pass.SearchProvider.ini

	insinto /usr/share/applications
	doins conf/org.gnome.Pass.SearchProvider.desktop

	insinto /usr/share/dbus-1/services
	newins conf/org.gnome.Pass.SearchProvider.service.dbus org.gnome.Pass.SearchProvider.service

	systemd_newuserunit conf/org.gnome.Pass.SearchProvider.service.systemd org.gnome.Pass.SearchProvider.service

	doicon -s 512 "${FILESDIR}"/password-manager.png
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
