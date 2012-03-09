# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games versionator

MY_PN="Cogs"
DESCRIPTION="An award-winning puzzle game where players build an incredible variety of machines from sliding tiles"
HOMEPAGE="http://www.cogsgame.com/"

HIBPAGE="http://www.humblebundle.com"
SRC_URI="${PN}_${PV}_all.tar.gz"

RESTRICT="fetch"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[audio,joystick,video]
	 media-libs/openal"

S="${WORKDIR}/data"

MY_P="${PN}_${PV}_all.tar.gz"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo "This ebuild was tested with tha package provided by the"
	einfo "Humble Indie Bundle #3. Any other HIB could have a different"
	einfo "package name"
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE} or ${HIBPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_unpack() {
	echo "${DISTDIR}/${A}"
	ls
	unpack "../distdir/${MY_P}" || die "unpack \"${P}\" failed"
	rm -f "${MY_P}" || die "remove \"${P}\" failed"
}

src_install() {
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	doins -r "cogs/data" || die "doins \"data\" failed"

	exeinto "${GAMEDIR}" || die "exeinto \${GAMEDIR}\" failed"
	newexe "cogs/${MY_PN}" "${PN}" || die "newexe \"${MY_PN}\" failed"
	amd64?
		doexe "cogs/${MY_PN}-amd64" || die "doexe \"${MY_PN}-x86\" failed"
	x86?
		doexe "cogs/${MY_PN}-x86" || die "doexe \"${MY_PN}-x86\" failed"

	# Make game wrapper
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file
	doicon "cogs/${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Install documentation
	dodoc cogs/*.txt || die "dodoc failed"

	# Setting permissions
	prepgamesdirs
}

pkg_postinst() {
	echo ""
	games_pkg_postinst

	einfo "Please report any bugs here:"
	einfo ""
	einfo "http://bugzilla.icculus.org/"
	echo ""
	einfo "An email list for discussion \(not bug reports!\) is available here:"
	einfo ""
	einfo "http://icculus.org/mailman/listinfo/cogs"
	echo ""
	einfo "${MY_PN} savegames are stored in the"
	einfo "\"\${HOME}/.local/share/${MY_PN}\" dir."
	echo ""
}
