# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
PYPI_NO_NORMALIZE=1

inherit distutils-r1 pypi

DESCRIPTION="A library for reading and writing Garmin FIT files"
HOMEPAGE="
	https://pypi.org/project/fit-tool/
	https://bitbucket.org/stagescycling/python_fit_tool/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/bitstruct[${PYTHON_USEDEP}]
	dev-python/openpyxl[${PYTHON_USEDEP}]
"
