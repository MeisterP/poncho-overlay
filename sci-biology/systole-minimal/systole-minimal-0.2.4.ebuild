# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Package for cardiac signal synchrony and analysis"
HOMEPAGE="
	https://systole-docs.github.io/
	https://github.com/embodied-computation-group/systole/
	https://pypi.org/project/systole/
	"

SRC_URI="https://github.com/embodied-computation-group/systole/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S=${WORKDIR}/${P/-minimal/}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/pandas[${PYTHON_USEDEP}]
	"

PATCHES=( "${FILESDIR}/remove-numba-sleepecg.patch" )

src_prepare() {
	rm -r systole/datasets systole/plots systole/recording.py || die
	sed -i -e "/.datasets/d" -e "/.plots/d" systole/__init__.py || die
	default
}
