# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

GIT_COMMIT=9574b30

DESCRIPTION="time-sync is a utility to sync the time with a Rockbox target"
HOMEPAGE="http://www.rockbox.org/wiki/IpodTimeSync"
SRC_URI="http://git.rockbox.org/?p=rockbox.git;a=snapshot;h=${GIT_COMMIT};sf=tgz
		-> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/sg3_utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rockbox-${GIT_COMMIT}/utils/time-sync"

src_install() {
	dobin time-sync
	dodoc README
}
