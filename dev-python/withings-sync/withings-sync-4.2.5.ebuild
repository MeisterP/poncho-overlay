# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Synchronisation of Withings weight"
HOMEPAGE="https://github.com/jaroslawhartman/withings-sync https://pypi.org/project/withings-sync/"
SRC_URI="https://github.com/jaroslawhartman/withings-sync/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/garth[${PYTHON_USEDEP}]
dev-python/lxml[${PYTHON_USEDEP}]
dev-python/requests[${PYTHON_USEDEP}]"

RESTRICT="test"
