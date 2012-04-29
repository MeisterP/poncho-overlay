# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI="4"

EGIT_REPO_URI="git://github.com/sorin-ionescu/${PN}.git"
EGIT_HAS_SUBMODULES="yes"

inherit git-2

DESCRIPTION="Directory of help-files (for run-help) for your current zsh"
HOMEPAGE="https://github.com/sorin-ionescu/oh-my-zsh"

LICENSE="ZSH"
SLOT="0"
KEYWORDS=""
IUSE=""
PROPERTIES="live"

RDEPEND="app-shells/zsh"

ZSH_DEST="${EPREFIX%/}/usr/share/zsh/site-contrib/${PN}"
ZSH_TEMPLATE="templates/zshrc"

src_prepare() {
    sed -i -e 's!$HOME/.oh-my-zsh!'"${ZSH_DEST}"'!' \
    "${S}/${ZSH_TEMPLATE}" || die "sed failed"
    for i in $(find "${S}" -name ".git*"); do rm -rf "$i"; done

}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

pkg_postinst() {
	elog "In order to use ${CATEGORY}/${PN} add to your ~/.zshrc"
	elog "source '${ZSH_DEST}/${ZSH_TEMPLATE}'"
	elog "or copy a modification of that file to your ~/.zshrc"
	elog "If you just want to try, enter the above command in your zsh."
}

