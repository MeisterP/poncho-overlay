# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI="4"
EGIT_REPO_URI="git://github.com/zsh-users/zsh-syntax-highlighting.git"
#EGIT_BRANCH="master"
EGIT_PROJECT="zsh-syntax-highlighting"
inherit eutils git-2

DESCRIPTION="Fish shell like syntax highlighting for zsh"
HOMEPAGE="https://github.com/zsh-users/zsh-syntax-highlighting"

LICENSE="as-is"
SLOT="0"
# Since this is a live ebuild, we require ACCEPT_KEYWORDS='**'
#KEYWORDS="~amd64 ~x86"
KEYWORDS=""
IUSE=""
PROPERTIES="live"

RDEPEND="app-shells/zsh"
DEPEND=""

#src_prepare () {
#    epatch ${FILESDIR}/fix-bad-pattern-error.diff
#}

src_install() {
	dodoc *.md
	insinto /usr/share/zsh/site-contrib
	doins *.zsh
	doins -r highlighters
}

pkg_postinst() {
	elog "In order to use ${CATEGORY}/${PN} add"
	elog ". /usr/share/zsh/site-contrib/zsh-syntax-highlighting.zsh"
	elog "at the end of your ~/.zshrc"
	elog "For testing, you can also execute the above command in your zsh."
}

