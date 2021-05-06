# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit desktop systemd python-single-r1

COMMIT="bbceb716b1c8713f3d598455237f3810e68cbc14"

DESCRIPTION="Pass password manager search provider for gnome-shell"
HOMEPAGE="https://github.com/jle64/gnome-pass-search-provider"
SRC_URI="https://github.com/jle64/gnome-pass-search-provider/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	app-admin/pass[X]
	$(python_gen_cond_dep '
		dev-python/fuzzywuzzy[${PYTHON_MULTI_USEDEP}]
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
	')"

S=${WORKDIR}/${PN}-${COMMIT}

src_install() {
	python_scriptinto /usr/lib/gnome-pass-search-provider
	python_doscript gnome-pass-search-provider.py

	insinto /usr/share/gnome-shell/search-providers
	doins conf/org.gnome.Pass.SearchProvider.ini

	domenu conf/org.gnome.Pass.SearchProvider.desktop

	insinto /usr/share/dbus-1/services
	newins conf/org.gnome.Pass.SearchProvider.service.dbus org.gnome.Pass.SearchProvider.service

	systemd_newuserunit conf/org.gnome.Pass.SearchProvider.service.systemd org.gnome.Pass.SearchProvider.service
}
