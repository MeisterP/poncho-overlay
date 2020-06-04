# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="static git page generator"
HOMEPAGE="https://git.codemadness.org/stagit/"
SRC_URI="https://codemadness.org/releases/stagit/stagit-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-libs/libgit2:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/0.9-gentoo-path.patch
	)
