# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="Garmin Connect activity exporter and backup tool"
HOMEPAGE="https://github.com/petergardfjall/garminexport https://pypi.org/project/garminexport/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+vanilla"

RDEPEND="dev-python/cloudscraper[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/garth[${PYTHON_USEDEP}]"

RESTRICT="test"

# https://github.com/petergardfjall/garminexport/pull/104
PATCHES=( "${FILESDIR}/0.4.2-garth.patch" )

src_prepare() {
	if ! use vanilla; then
		PATCHES+=( "${FILESDIR}/0.4.2-use-the-same-filename-as-edge.patch" )
	fi

	sed -e 's/license_file/license_files/g' -i setup.cfg || die

	default
}
