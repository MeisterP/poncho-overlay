# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

SNAPSHOT="c7f9c475dd9130659001d06c5ddf3cbc224db390"

DESCRIPTION="QPlatformTheme for a better Qt application inclusion in GNOME"
HOMEPAGE="https://github.com/MartinBriza/QGnomePlatform"
#SRC_URI="https://github.com/MartinBriza/${PN}/archive/${PV}.tar.gz"
SRC_URI="https://github.com/MartinBriza/QGnomePlatform/archive/${SNAPSHOT}.zip -> ${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# https://bugzilla.gnome.org/show_bug.cgi?id=762681
DEPEND=">=dev-qt/qtcore-5.5:="
RDEPEND="${DEPEND}
	>=gnome-base/gnome-session-3.20.0"

S="${WORKDIR}/${PN}-${SNAPSHOT}"

src_compile() {
	eqmake5
}

src_install() {
	INSTALL_ROOT="${D}" emake install
	dodoc README.md
}
