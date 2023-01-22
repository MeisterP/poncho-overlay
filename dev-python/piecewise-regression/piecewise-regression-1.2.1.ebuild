# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..10} )
inherit distutils-r1

DESCRIPTION="piecewise-regression (aka segmented regression) in python"
HOMEPAGE="
	https://piecewise-regression.readthedocs.io/
	https://github.com/chasmani/piecewise-regression/
	https://pypi.org/project/piecewise-regression/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/statsmodels[${PYTHON_USEDEP}]
	"
BDEPEND=""

DOCS=( docs/README.rst )

src_prepare() {
	rm -rf tests || die
	default
}
