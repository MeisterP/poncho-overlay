# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="NOnLinear measures for Dynamical Systems (nolds)"
HOMEPAGE="
	https://github.com/CSchoel/nolds/
	https://pypi.org/project/nolds/
	"
SRC_URI="https://github.com/CSchoel/nolds/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="
	dev-python/future[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scikit-learn[${PYTHON_USEDEP}]
	"
BDEPEND=""

src_prepare() {
	sed -i -e "/'clean': CleanCommand/d" setup.py || die
	default
}
