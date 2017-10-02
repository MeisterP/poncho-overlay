# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="GPlayCli, a Google play downloader command line interface"
HOMEPAGE="https://github.com/matlink/gplaycli"
SRC_URI="https://github.com/matlink/gplaycli/archive/2.15.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

#python2 -> androguard
#python3 -> pyaxmlparser

DEPEND="${PYTHON_DEPS}
	dev-python/clint[${PYTHON_USEDEP}]
	dev-python/ndg-httpsclient[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pyaxmlparser[${PYTHON_USEDEP}]
	dev-python/pycrypto[${PYTHON_USEDEP}]
	>=dev-python/requests-0.12[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PV}-config.patch" "${FILESDIR}/${PV}-language.patch" )
