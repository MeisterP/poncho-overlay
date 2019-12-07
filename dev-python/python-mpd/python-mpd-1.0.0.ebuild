# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy )

inherit distutils-r1

DESCRIPTION="Python MPD client library"
HOMEPAGE="https://github.com/Mic92/python-mpd2"
SRC_URI="https://github.com/Mic92/${PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( doc/changes.rst doc/topics/{advanced,commands,getting-started,logging}.rst README.rst )

S="${WORKDIR}/${PN}2-${PV}"

python_test() {
	"${PYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
