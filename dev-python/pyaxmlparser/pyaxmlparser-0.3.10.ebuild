# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Python3 Parser for Android XML file"
HOMEPAGE="https://github.com/appknox/pyaxmlparser"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=dev-python/click-6.7[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.7.3[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
