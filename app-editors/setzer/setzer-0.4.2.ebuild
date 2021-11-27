# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{7..9} )

inherit meson python-single-r1 xdg

DESCRIPTION="Simple yet full-featured LaTeX editor written in Python with Gtk"
HOMEPAGE="https://www.cvfosammmm.org/setzer/"
SRC_URI="https://github.com/cvfosammmm/Setzer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/pexpect[${PYTHON_USEDEP}]
			app-text/pdfminer[${PYTHON_USEDEP}]
		')

"
BDEPEND=""

src_install() {
	meson_src_install
	python_optimize
}

S=${WORKDIR}/Setzer-${PV}
