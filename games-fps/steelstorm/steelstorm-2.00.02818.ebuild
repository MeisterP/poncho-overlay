# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils games

DESCRIPTION="Steel Storm Episode 2 game data"
HOMEPAGE="http://www.steel-storm.com/"
RESTRICT="mirror"
SRC_URI="steelstorm-br-${PV}-release.tar.gz"

LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"

SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=media-libs/libsdl-1.2
	>=media-libs/freetype-2.3.11
	>=media-libs/libogg-1.1.4
	>=media-libs/libvorbis-1.2.3
	media-libs/libpng
	virtual/jpeg
	virtual/opengl"

S="${WORKDIR}/${PN}"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

src_install() {
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	doins -r "gamedata" || die "doins \"gamedata\" failed"

	exeinto "${GAMEDIR}" || die "exeinto \${GAMEDIR}\" failed"
	if use amd64
	then
		newexe "${PN}64" "${PN}" || die "newexe \"${MY_PN}64\" failed"
	fi
	if use x86
	then
		newexe "${PN}" "${PN}" || die "newexe \"${PN}\" failed"
	fi

	# Make game wrapper
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file
	newicon ./icons/ss_ep2_icon_128.png "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "SteelStorm" "${PN}" || die "make_desktop_entry failed"

	# Install documentation
	dodoc *.txt || die "dodoc failed"

	# Setting permissions
	prepgamesdirs
}
