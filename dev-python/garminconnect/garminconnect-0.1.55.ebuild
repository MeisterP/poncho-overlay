# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 API wrapper for Garmin Connect"
HOMEPAGE="https://github.com/cyberjunky/python-garminconnect https://pypi.org/project/garminconnect/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="dev-python/cloudscraper[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"
BDEPEND=""
