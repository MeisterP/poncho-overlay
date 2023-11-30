# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

MY_COMMIT="05af4878d5d528b9cccc721a81b549fa2b209c34"

DESCRIPTION="Intersection of curves in python"
HOMEPAGE="
	https://pypi.org/project/intersect/
	https://github.com/sukhbinder/intersection
"
SRC_URI="https://github.com/sukhbinder/intersection/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	"
BDEPEND=""

DOCS=( readme.md )

S="${WORKDIR}/intersection-${MY_COMMIT}"

src_prepare() {
	sed -i -e "s:packages=find_packages(),:packages=find_packages(exclude=('tests',)),:" setup.py || die
	default
}
