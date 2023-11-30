# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="NOnLinear measures for Dynamical Systems (nolds)"
HOMEPAGE="https://github.com/CSchoel/nolds/ https://pypi.org/project/nolds/"
SRC_URI="https://github.com/CSchoel/nolds/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
	"

PATCHES=( "${FILESDIR}/0001-drop-support-for-python-2.7-don-t-depend-on-future.patch" )

src_prepare() {
	sed -i -e "/'clean': CleanCommand/d" setup.py || die
	default
}

distutils_enable_tests pytest
