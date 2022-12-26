# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit python-single-r1 autotools optfeature

MY_COMMIT="55465b8cf6b6b48fb45da43a8579ad335809c99a"

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"
HOMEPAGE="https://github.com/eonpatapon/mpDris2"
#SRC_URI="https://github.com/eonpatapon/mpDris2/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/eonpatapon/mpDris2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="$(python_gen_cond_dep '
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-mpd[${PYTHON_USEDEP}]
	')"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

#S="${WORKDIR}/mpDris2-${PV}"
S="${WORKDIR}/mpDris2-${MY_COMMIT}"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	python_fix_shebang "${ED}/usr/bin/mpDris2"
}

pkg_postinst() {
	optfeature "notifications on track change" x11-libs/libnotify[introspection]
	optfeature "read covers from music files" media-libs/mutagen
}
