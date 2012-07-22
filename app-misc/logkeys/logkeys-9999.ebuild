# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="A GNU/Linux keylogger that works!"
HOMEPAGE="http://code.google.com/p/logkeys/"
#SRC_URI="http://logkeys.googlecode.com/files/logkeys-${PV}.tar.gz -> ${P}.tar.gz"
EGIT_REPO_URI="https://code.google.com/p/${PN}/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	default
	insinto /usr/share/${PN}/
	doins "${FILESDIR}"/*.map
}
