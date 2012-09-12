# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="A GNU/Linux keylogger that works!"
HOMEPAGE="http://code.google.com/p/logkeys/"
EGIT_REPO_URI="https://code.google.com/p/${PN}/"

#KMAP="en_GB fr_CH fr fr-dvorak-bepo de hu it pt_BR pt_PT ro ru sk_QWERTY sk_QWERTZ sl es_AR es_ES sv tr"
#for kmap in $KMAP; do
#	SRC_URI+=" http://wiki.logkeys.googlecode.com/git/keymaps/${kmap}.map"
#done

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
