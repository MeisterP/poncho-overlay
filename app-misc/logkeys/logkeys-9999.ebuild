# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils git-2

DESCRIPTION="A GNU/Linux keylogger that works!"
HOMEPAGE="http://code.google.com/p/logkeys/"
EGIT_REPO_URI="https://code.google.com/p/${PN}/"

KMAP="en_GB fr_CH fr fr-dvorak-bepo de hu it pt_BR pt_PT ro ru sk_QWERTY sk_QWERTZ sl es_AR es_ES sv tr"
for kmap in $KMAP; do
	SRC_URI+=" http://wiki.logkeys.googlecode.com/git/keymaps/${kmap}.map"
done

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
	for kmap in $KMAP; do
		doins "${DISTDIR}/${kmap}.map"
	done
	doins "${FILESDIR}"/de-ch.map

	newinitd "${FILESDIR}/${PN}-init.d" ${PN}
	newconfd "${FILESDIR}/${PN}-conf.d" ${PN}

	if ! use suid; then
		rm -f "${D}"/etc/logkeys-{kill,start}.sh || die
		rm -f "${D}"/usr/bin/llk{,k} || die
	fi
}
