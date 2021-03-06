# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Generate complex HTML+JS pages with Python"
HOMEPAGE="https://github.com/python-visualization/branca"
SRC_URI="mirror://pypi/b/branca/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/jinja[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
