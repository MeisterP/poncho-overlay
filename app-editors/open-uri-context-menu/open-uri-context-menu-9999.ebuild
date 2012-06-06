# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://jpfleury.indefero.net/jpfleury/${PN}.git"

inherit multilib git-2

DESCRIPTION="Gedit plugin to open a URI from context menu"
HOMEPAGE="http://www.jpfleury.net/en/software/open-uri-context-menu.php"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		>=app-editors/gedit-3.2.6
		x11-misc/xdg-utils"

src_install() {
	insinto /usr/$(get_libdir)/gedit/plugins/${PN}
	doins ${PN}.{plugin,py}
	dodoc doc/{LISEZ-MOI,README}.mkd
}

