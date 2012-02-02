# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header $

EAPI="4"

EGIT_REPO_URI="git://github.com/robbyrussell/${PN}.git"
[ -n "${EVCS_OFFLINE}" ] || EGIT_REPACK=true
inherit git-2

DESCRIPTION="Directory of help-files (for run-help) for your current zsh"
HOMEPAGE="https://github.com/robbyrussell/oh-my-zsh"

LICENSE="ZSH"
SLOT="0"
KEYWORDS=""
IUSE=""
PROPERTIES="live"

RDEPEND="app-shells/zsh"

ZSH_DEST="${EPREFIX%/}/usr/share/zsh/site-contrib/${PN}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

src_prepare() {
	local i
	for i in "${S}"/tools/*install* "${S}"/tools/*upgrade*
	do	test -f "${i}" && : >"${i}"
	done
	sed -i -e 's!^ZSH=.*$!ZSH='"${ZSH_DEST}"'!' \
		   -e 's!~/.oh-my-zsh!'"${ZSH_DEST}"'!' "${S}/${ZSH_TEMPLATE}"
	sed -i -e 's!~/.oh-my-zsh!'"${ZSH_DEST}"'!' \
		"${S}/plugins/dirpersist/dirpersist.plugin.zsh"
	sed -i -e '/zstyle.*cache/d' "${S}/lib/completion.zsh"
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

