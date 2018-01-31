# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="static git page generator"
HOMEPAGE="http://git.2f30.org/stagit/"
SRC_URI="http://dl.2f30.org/releases/stagit-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libgit2"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PV}-gentoo-path.patch" )
