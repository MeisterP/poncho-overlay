# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
inherit distutils-r1

COMMIT=c789893237967ca4c5640e4c4e7d9f904b67e307

DESCRIPTION="Python library to parse ANT/Garmin .FIT files"
HOMEPAGE="https://github.com/dtcooper/python-fitparse https://pythonhosted.org/fitparse/"
SRC_URI="https://github.com/dtcooper/python-fitparse/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/0001-update-profile.py-for-SDK-20.88.patch
	"${FILESDIR}"/0002-update-profile.py-for-SDK-21.16.patch
	"${FILESDIR}"/0003-update-profile.py-for-SDK-21.18.patch
	"${FILESDIR}"/0004-update-profile.py-for-SDK-21.30.patch
	)

DOCS=( README.md CONTRIBUTING.md )

S=${WORKDIR}/python-fitparse-${COMMIT}

python_test() {
	"${EPYTHON}" ./run_tests.py || die "Tests fail with ${EPYTHON}"
}
