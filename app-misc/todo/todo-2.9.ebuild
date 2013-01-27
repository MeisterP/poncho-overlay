# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit bash-completion-r1

DESCRIPTION="A command-line TODO manager"
HOMEPAGE="http://todotxt.com/"
SRC_URI="mirror://github/ginatrapani/todo.txt-cli/todo.txt_cli-${PV}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	app-shells/bash"

S="${WORKDIR}/todo.txt_cli-${PV}"

src_install () {
	dobin todo.sh
	dodoc todo.cfg
	dobashcomp todo_completion
}

pkg_postinst() {
	einfo "Todo requires the ~/.todo/config configuration file to run"
	einfo "You can find a todo.cfg example in /usr/share/doc/${PF}/"
}
