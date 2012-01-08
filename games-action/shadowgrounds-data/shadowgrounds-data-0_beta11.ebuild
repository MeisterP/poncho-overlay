# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games

DESCRIPTION="Shadowgrounds - data portion"
HOMEPAGE="http://shadowgroundsgame.com/"
SRC_URI="shadowgroundsUpdate1.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

RDEPEND=""

S=${WORKDIR}

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	unzip -q "${DISTDIR}/${A}"
}

src_install() {
	local dir="${GAMES_DATADIR}/shadowgrounds"

	ebegin "Copying files from package ..."
		dodir "${dir}"/data
		cp -r data1.fbz data "${D}${dir}" || die "cp failed"
	eend 0

	prepgamesdirs
}
