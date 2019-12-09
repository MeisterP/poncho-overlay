# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7,8} )

inherit distutils-r1

DESCRIPTION="Python SVG document creation library"
HOMEPAGE="https://github.com/alorence/pysvg-py3"
SRC_URI="https://files.pythonhosted.org/packages/63/92/a0d9d3c3f339bdd7f364e3e85033fc7649bb59d651dbab88ef9774e4cdaf/${P}.post3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""

S="${WORKDIR}/${P}.post3"
