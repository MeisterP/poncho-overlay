# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{5,6,7} )

inherit python-single-r1 autotools eutils

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"
HOMEPAGE="https://github.com/eonpatapon/mpDris2"
SRC_URI="https://github.com/eonpatapon/mpDris2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-mpd[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/mpDris2-${PV}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	python_fix_shebang "${ED}/usr/bin/mpDris2"
}

pkg_postinst() {
	elog "To get additional features, a number of optional runtime"
	elog "dependencies may be installed:"
	optfeature "notifications on track change" dev-python/notify-python
	optfeature "read covers from music files" media-libs/mutagen
}
