# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

MY_PN="darksky_weather"

DESCRIPTION="Python API wrapper for the DarkSky"
HOMEPAGE="https://github.com/Detrous/darksky"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND=">=dev-python/requests-2.21.0[${PYTHON_USEDEP}]
	>=dev-python/pytz-2019.1[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.5.4[${PYTHON_USEDEP}]"
BDEPEND=""

PATCHES=( "${FILESDIR}/${PV}-no-tests-install.patch" )

S="${WORKDIR}/${MY_PN}-${PV}"
