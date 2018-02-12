# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils

DESCRIPTION="GTK 3 client for the Music Player Daemon"
HOMEPAGE="https://github.com/multani/sonata"
MY_COMMIT="0a1d63022720f95d092cc82da53f2b210d2ed26a"
SRC_URI="https://github.com/multani/sonata/archive/${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-mpd[${PYTHON_USEDEP}]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/sonata-${MY_COMMIT}"

PATCHES=( "${FILESDIR}/link-color.patch" )

pkg_postinst() {
	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	optfeature "multimedia key support" dev-python/dbus-python
	optfeature "editing metadata" dev-python/tagpy
}

src_install() {
	distutils-r1_src_install
	rm -rf "${D}"/usr/share/sonata || die
	insinto /usr/share/pixmaps
	newins sonata/pixmaps/sonata-large.png sonata.png
}
