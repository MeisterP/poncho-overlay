# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Scan for movies, query imdb and generate a catalog."
HOMEPAGE="https://github.com/damienlangg/SimpleMovieCatalog"
EGIT_REPO_URI="https://github.com/damienlangg/SimpleMovieCatalog.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="dev-lang/perl
	 dev-perl/libwww-perl"
RDEPEND="${DEPEND}"

PATCHES=( ${FILESDIR}/storyline-extraction.patch )

src_prepare(){
	default
	sed -i 's/^my $system_install = 0;/my $system_install = 1;/' moviecat.pl || die
}

src_install() {
	dobin moviecat.pl
	dosym moviecat.pl /usr/bin/moviecat
	insinto /usr/share/smoviecat
	doins -r lib
	dodoc doc/{changelog,sample-cfg}.txt README.md
}
