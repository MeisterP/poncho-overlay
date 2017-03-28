# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_HASH="e7e37c10762d3da0829ecdbe6f01400fbbb147bc"

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/MartinBriza/adwaita-qt"
#SRC_URI="https://github.com/MartinBriza/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/MartinBriza/${PN}/archive/${MY_HASH}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_HASH}"

src_compile() {
	QT_SELECT=5 cmake-utils_src_compile
}
