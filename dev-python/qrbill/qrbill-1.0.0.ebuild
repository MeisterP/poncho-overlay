# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_10 )
inherit distutils-r1

DESCRIPTION="A library to generate Swiss QR-bill payment slips"
HOMEPAGE="https://github.com/claudep/swiss-qr-bill/ https://pypi.org/project/qrbill/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="test"

RDEPEND="dev-python/iso3166[${PYTHON_USEDEP}]
	dev-python/python-stdnum[${PYTHON_USEDEP}]
	dev-python/qrcode[${PYTHON_USEDEP}]
	dev-python/svgwrite[${PYTHON_USEDEP}]"
BDEPEND=""

S=${WORKDIR}/swiss-qr-bill-${PV}

src_prepare() {
	rm -rf tests || die
	default
}
