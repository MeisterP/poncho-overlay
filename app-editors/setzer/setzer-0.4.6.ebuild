# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..9} )

inherit meson python-single-r1 xdg

DESCRIPTION="Simple yet full-featured LaTeX editor written in Python with Gtk"
HOMEPAGE="https://www.cvfosammmm.org/setzer/"
SRC_URI="https://github.com/cvfosammmm/Setzer/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		app-text/pdfminer[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
	')
	app-text/gspell
	app-text/poppler
	dev-tex/latexmk
	x11-libs/gtksourceview:4"
BDEPEND=""

src_install() {
	meson_src_install
	python_optimize
}

S=${WORKDIR}/Setzer-${PV}
