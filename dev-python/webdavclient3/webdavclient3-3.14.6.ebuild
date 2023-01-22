# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="Python WebDAV Client 3"
HOMEPAGE="https://github.com/ezhov-evgeny/webdav-client-python-3"
SRC_URI="https://github.com/ezhov-evgeny/webdav-client-python-3/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"
# No connection with http://localhost:8585

DEPEND="dev-python/certifi[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]"
	#	dev-python/oauthlib[${PYTHON_USEDEP}]
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/webdav-client-python-3-${PV}

python_prepare() {
	sed -i -e "s/find_packages()/find_packages(exclude=['tests'])/" setup.py || die
}
