# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Garmin SSO auth + Connect Python client"
HOMEPAGE="https://github.com/matin/garth https://pypi.org/project/garth/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2.11.7[${PYTHON_USEDEP}]
	dev-python/pydantic-settings[${PYTHON_USEDEP}]
	>=dev-python/requests-oauthlib-1.3.1[${PYTHON_USEDEP}]
"

python_install() {
	distutils-r1_python_install

	newenvd - 90garth <<-EOF
		# https://github.com/matin/garth/blob/main/docs/telemetry.md#why-telemetry-is-on-by-default
		GARTH_TELEMETRY_ENABLED=false
	EOF
}
