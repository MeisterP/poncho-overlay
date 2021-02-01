# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit distutils-r1

COMMIT=c5865d712da8b7a1cef08329366e131fc3e19305

DESCRIPTION="Python library to parse ANT/Garmin .FIT files"
HOMEPAGE="https://github.com/dtcooper/python-fitparse https://pythonhosted.org/fitparse/"
#SRC_URI="https://github.com/dtcooper/python-fitparse/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/MeisterP/python-fitparse/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( README.md CONTRIBUTING.md )

S=${WORKDIR}/python-fitparse-${COMMIT}

python_test() {
	"${EPYTHON}" ./run_tests.py || die "Tests fail with ${EPYTHON}"
}
