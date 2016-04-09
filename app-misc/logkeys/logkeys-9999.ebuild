# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools git-r3 systemd

DESCRIPTION="A GNU/Linux keylogger that works!"
HOMEPAGE="https://github.com/kernc/logkeys"
EGIT_REPO_URI="https://github.com/kernc/logkeys.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="suid"

DEPEND=""
RDEPEND=""

PATCHES=( "${FILESDIR}/cxxflags.patch" )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	insinto /usr/share/${PN}/
	doins keymaps/*.map

	newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	newconfd "${FILESDIR}/${PN}-conf.d" ${PN}

	systemd_dounit "${FILESDIR}/logkeys.service"
	systemd_install_serviced "${FILESDIR}/logkeys.service.conf"

	if ! use suid; then
		rm -f "${D}"/etc/logkeys-{kill,start}.sh || die
		rm -f "${D}"/usr/bin/llk{,k} || die
	fi
}
