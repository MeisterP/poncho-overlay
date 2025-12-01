# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Library that simplifies creating user interfaces with wxPython"
HOMEPAGE="https://github.com/thetimelineproj/humblewx"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"
