# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="QPlatformTheme for a better Qt application inclusion in GNOME"
HOMEPAGE="https://github.com/MartinBriza/QGnomePlatform"
SRC_URI="https://github.com/MartinBriza/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-qt/qtcore-5.5:="
RDEPEND="${DEPEND}
	>=gnome-base/gnome-session-3.20.0"

src_compile() {
	eqmake5
}

src_install() {
	INSTALL_ROOT="${D}" emake install
	dodoc README.md
}
