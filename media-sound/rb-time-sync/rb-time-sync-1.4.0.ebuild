# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="time-sync is a utility to sync the time with a Rockbox target"
HOMEPAGE="http://www.rockbox.org/wiki/IpodTimeSync"
SRC_URI="https://github.com/Rockbox/rockbox/archive/rbutil_${PV}.tar.gz
		-> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-apps/sg3_utils"
RDEPEND="${DEPEND}"

S="${WORKDIR}/rockbox-rbutil_${PV}/utils/time-sync/"

src_install() {
	dobin time-sync
	dodoc README
}
