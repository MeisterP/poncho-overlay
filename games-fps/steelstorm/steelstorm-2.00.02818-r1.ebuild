# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils games

DESCRIPTION="Steel Storm Episode 2 game data"
HOMEPAGE="http://www.steel-storm.com/"
RESTRICT="mirror"
SRC_URI="steelstorm-br-${PV}-release.tar.gz"

LICENSE=""
RESTRICT="fetch strip"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=games-fps/darkplaces-20110628"

S=${WORKDIR}/${PN}

src_install() {
    # Install data
	insinto ${GAMES_DATADIR}/${PN}
    doins -r gamedata || die "doins failed"
    
    # Install wrapper
	cat <<- EOF > ${S}/${PN}.sh
		#!/bin/bash
		darkplaces -"${PN}" -basedir "${GAMES_DATADIR}/${PN}"
	EOF
    newbin ${S}/${PN}.sh ${PN} || die "newbin failed"

	# Install icon and desktop file
	newicon ./icons/ss_ep2_icon_128.png "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "SteelStorm" "${PN}" || die "make_desktop_entry failed"

	# Install documentation
	dodoc *.txt || die "dodoc failed"

	# Setting permissions
	prepgamesdirs
}
