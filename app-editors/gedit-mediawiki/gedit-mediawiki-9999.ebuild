# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

EGIT_REPO_URI="git://jpfleury.indefero.net/jpfleury/${PN}.git"

inherit multilib git-2

DESCRIPTION="Gedit-mediawiki adds MediaWiki syntax highlighting in gedit"
HOMEPAGE="http://www.jpfleury.net/en/software/gedit-mediawiki.php"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		>=app-editors/gedit-3.2.6
		x11-libs/gtksourceview:3.0"

src_install() {
	insinto /usr/share/gtksourceview-3.0/language-specs
	doins mediawiki.lang
	dodoc doc/{LISEZ-MOI,README}.mkd
}
