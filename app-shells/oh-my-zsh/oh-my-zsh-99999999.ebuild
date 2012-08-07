# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

EGIT_REPO_URI="git://github.com/sorin-ionescu/prezto.git"
EGIT_HAS_SUBMODULES="yes"
EGIT_COMMIT="df82640caa4a5292eb204001248e5dd3c9f24468"

inherit git-2

DESCRIPTION="Directory of help-files (for run-help) for your current zsh"
HOMEPAGE="https://github.com/sorin-ionescu/oh-my-zsh"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""
PROPERTIES="live"

RDEPEND="app-shells/zsh"

ZSH_DEST="${EPREFIX%/}/usr/share/zsh/site-contrib/${PN}"

src_prepare() {
	sed -i -e 's!$HOME/.oh-my-zsh!'"${ZSH_DEST}"'!' \
	"${S}/runcoms/zshenv" || die "sed failed"

	for gitfile in $(find "${S}" -name ".git*");
		do rm -rf "${gitfile}"
	done

}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *

	insinto /etc/zsh
	for rcfile in "${S}"/runcoms/z{shenv,shrc,login,logout}; do
		doins "${rcfile}"
	done
}

pkg_postinst() {
	elog "In order to customize ${CATEGORY}/${PN} edit /etc/zsh/zshrc"
	elog "or copy a modification of that file to your ~/.zshrc"
}
