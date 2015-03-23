# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-r3 systemd

DESCRIPTION="A GNU/Linux keylogger that works!"
HOMEPAGE="https://github.com/MeisterP/logkeys http://code.google.com/p/logkeys/"
EGIT_REPO_URI="https://github.com/MeisterP/logkeys.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="suid"

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/cxxflags.patch"
	eautoreconf
}

src_install() {
	default

	insinto /usr/share/${PN}/
	doins "${FILESDIR}"/*.map

	newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	newconfd "${FILESDIR}/${PN}-conf.d" ${PN}

	systemd_dounit "${FILESDIR}/logkeys.service"
	systemd_install_serviced "${FILESDIR}/logkeys.service.conf"

	if ! use suid; then
		rm -f "${D}"/etc/logkeys-{kill,start}.sh || die
		rm -f "${D}"/usr/bin/llk{,k} || die
	fi
}
