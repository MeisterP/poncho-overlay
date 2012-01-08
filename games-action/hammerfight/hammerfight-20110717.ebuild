# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

MY_PN="Hammerfight"
DESCRIPTION="A game about 2D battles of flying machines equipped with various slashing, piercing and blunt weaponry"
HOMEPAGE="http://www.koshutin.com/"

HIBPAGE="http://www.humblebundle.com"
SRC_URI="hf-linux-${PV:4}${PV:0:4}-bin"
ZIP_OFFSET="192708"

RESTRICT="fetch"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[audio,joystick,video]
	 media-libs/openal
	amd64? ( app-emulation/emul-linux-x86-sdl )"

S="${WORKDIR}/data"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "   ${HIBPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_unpack() {
	tail --bytes=+$(( ${ZIP_OFFSET} + 1 )) "${DISTDIR}/${A}" > "${P}.zip" || die "tail \"${DISTDIR}/${A}\" failed"
	unpack "./${P}.zip" || die "unpack \"${P}\" failed"
	rm -f "${P}.zip" || die "remove \"${P}\" failed"
}

src_install() {
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	# Dirs:
	find . -maxdepth 1 -mindepth 1 -type d | xargs doins -r || die "doins failed"
	# Configs:
	doins *.ini *.script strings.txt || die "doins failed"

	exeinto "${GAMEDIR}" || die "exeinto \${GAMEDIR}\" failed"
	newexe "${MY_PN}" "${PN}" || die "newexe \"${MY_PN}\" failed"

	# Make game wrapper
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file
	doicon "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Install documentation
	find . -maxdepth 1 -iname "readme*" | xargs dodoc || die "dodoc failed"

	# Setting permissions
	prepgamesdirs
}

pkg_postinst() {
	echo ""
	games_pkg_postinst

	einfo "Please report any bugs here:"
	einfo "   http://bugzilla.icculus.org/"
	einfo "An email list for discussion (not bug reports!) is available here:"
	einfo "   http://icculus.org/mailman/listinfo/${PN}"
	echo ""
	einfo "${MY_PN} savegames and configurations are stored in:"
	einfo "   \${HOME}/.local/share/${MY_PN}"
	einfo "If you are experiencing problems of slowness, try to set:"
	einfo "   \"CORE_USE_SLEEP=false\""
	einfo "in the \"Config.ini\" file."
	echo ""
}
