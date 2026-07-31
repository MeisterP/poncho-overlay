# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 API wrapper for Garmin Connect"
HOMEPAGE="https://github.com/cyberjunky/python-garminconnect https://pypi.org/project/garminconnect/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	>=dev-python/curl-cffi-0.6[${PYTHON_USEDEP}]
	>=dev-python/requests-2.28[${PYTHON_USEDEP}]
	>=dev-python/ua-generator-1.0[${PYTHON_USEDEP}]
"
