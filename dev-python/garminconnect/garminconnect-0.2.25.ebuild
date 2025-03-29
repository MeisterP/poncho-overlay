# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Python 3 API wrapper for Garmin Connect"
HOMEPAGE="https://github.com/cyberjunky/python-garminconnect https://pypi.org/project/garminconnect/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND=">=dev-python/garth-0.5.2[${PYTHON_USEDEP}]
	~dev-python/withings-sync-4.2.5[${PYTHON_USEDEP}]"
