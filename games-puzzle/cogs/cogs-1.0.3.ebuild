# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games versionator

MY_PN="Cogs"
DESCRIPTION="An award-winning puzzle game where players build an incredible variety of machines from sliding tiles"
HOMEPAGE="http://www.cogsgame.com/"

HIBPAGE="http://www.humblebundle.com"
SRC_URI="${PN}-installer-build$(get_version_component_range 3)"
ZIP_OFFSET="192708"

RESTRICT="fetch"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[audio,joystick,video]
	 media-libs/openal"

S="${WORKDIR}/data"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "  ${HIBPAGE}"
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
	doins -r "data" || die "doins \"data\" failed"

	exeinto "${GAMEDIR}" || die "exeinto \${GAMEDIR}\" failed"
	if use amd64
	then
		newexe "${MY_PN}-amd64" "${PN}" || die "newexe \"${MY_PN}-amd64\" failed"
	fi
	if use x86
	then
		newexe "${MY_PN}-x86" "${PN}" || die "newexe \"${MY_PN}-x86\" failed"
	fi

	# Make game wrapper
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file
	doicon "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Install documentation
	dodoc *.txt || die "dodoc failed"

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
	echo ""
}
