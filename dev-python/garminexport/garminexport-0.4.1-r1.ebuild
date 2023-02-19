# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Garmin Connect activity exporter and backup tool"
HOMEPAGE="https://github.com/petergardfjall/garminexport https://pypi.org/project/garminexport/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="+vanilla"
KEYWORDS="~amd64"

DEPEND="dev-python/cloudscraper[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=( "${FILESDIR}/fix_the_404_errors.patch" )

src_prepare() {
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/0.3.0-use-the-same-filename-as-edge.patch" )
	fi

	distutils-r1_python_prepare_all
}
