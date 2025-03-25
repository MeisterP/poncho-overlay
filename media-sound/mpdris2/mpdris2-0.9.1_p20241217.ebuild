# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit python-single-r1 autotools optfeature

MY_COMMIT="e40238ba1d3c7a81d34e5f96b150e40b5b29d4af"

DESCRIPTION="An implementation of the MPRIS 2 interface as a client for MPD"

HOMEPAGE="https://github.com/eonpatapon/mpDris2"
SRC_URI="https://github.com/eonpatapon/mpDris2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/mpDris2-${MY_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="$(python_gen_cond_dep '
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-mpd2[${PYTHON_USEDEP}]
	')"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}"

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
