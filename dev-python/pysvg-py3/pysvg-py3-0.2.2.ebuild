# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{5,6,7} )

inherit distutils-r1

DESCRIPTION="Python SVG document creation library"
HOMEPAGE="https://github.com/alorence/pysvg-py3"
SRC_URI="https://files.pythonhosted.org/packages/cf/86/ee1c6cfa9d50425e33707462b5e1cf6f4679faf006206c40d00c6c73c228/${P}.post2.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""

S="${WORKDIR}/${P}.post2"
