# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

COMMIT=69bb319d690d5f1ac2b40b03de4d023003c63db1

DESCRIPTION="Python library to parse ANT/Garmin .FIT files"
HOMEPAGE="https://github.com/dtcooper/python-fitparse https://pythonhosted.org/fitparse/"
#SRC_URI="https://github.com/dtcooper/python-fitparse/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/MeisterP/python-fitparse/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

DOCS=( README.md CONTRIBUTING.md )

S=${WORKDIR}/python-fitparse-${COMMIT}

python_test() {
	"${EPYTHON}" ./run_tests.py || die "Tests fail with ${EPYTHON}"
}
