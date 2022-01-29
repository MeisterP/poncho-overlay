# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Fast audio loudness scanner & tagger (ReplayGain v2 / R128)"
HOMEPAGE="https://github.com/desbma/r128gain"
SRC_URI="https://github.com/desbma/r128gain/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="${PYTHON_DEPS}"
RDEPEND="${PYTHON_DEPS}
	>=dev-python/crcmod-1.7[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.23.3[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.43[${PYTHON_USEDEP}]
	>=media-video/ffmpeg-4.2"
