# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Garmin SSO auth + Connect Python client"
HOMEPAGE="https://github.com/matin/garth https://pypi.org/project/garth/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-1.10.12[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-1.3.1[${PYTHON_USEDEP}]
"
