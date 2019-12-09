# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 eutils desktop

DESCRIPTION="GTK 3 client for the Music Player Daemon"
HOMEPAGE="https://github.com/multani/sonata"
MY_COMMIT="cee3555d05d09ee96f011ad3f01058ca4c7b15bd"
SRC_URI="https://github.com/multani/sonata/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

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

src_install() {
	distutils-r1_src_install
	rm -rf "${D}"/usr/share/sonata || die
	newicon sonata/pixmaps/sonata-large.png sonata.png
}

pkg_postinst() {
	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	optfeature "multimedia key support" dev-python/dbus-python
	optfeature "editing metadata" dev-python/tagpy
}
