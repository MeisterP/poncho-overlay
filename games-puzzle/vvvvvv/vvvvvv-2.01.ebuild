# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils games

MY_PN="VVVVVV"
DESCRIPTION="A 2D puzzle platform video game"
HOMEPAGE="http://thelettervsixtim.es"

HIBPAGE="http://www.humblebundle.com"
SRC_URI="${MY_PN}_${PV}_Linux.tar.gz"

RESTRICT="fetch strip"
LICENSE=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl[audio,joystick,video]
         media-libs/sdl-image
         media-libs/sdl-mixer"

S="${WORKDIR}/${MY_PN}"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

ICONFILE="32_2.png"
MVDIR="${WORKDIR}/tmp"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "  ${HIBPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_prepare() {
	MOVE="data/icons/${ICONFILE}"
	REMOVE="LIB*
		${MY_PN}
		data/icons"

	[[ ! -d "${MVDIR}" ]] && ( mkdir "${MVDIR}" || die "mkdir \"${MVDIR}\" failed" ) || die "\"${MVDIR}\" exists"
	for move in ${MOVE}
	do
		mv "${S}/"${move} "${MVDIR}" || die "mv \"${move}\" failed"
	done

	for remove in ${REMOVE}
	do
		rm -r "${S}/"${remove} || die "rm \"${remove}\" failed"
	done
}

src_install() {
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	doins -r "data" || die "doins \"data\" failed"

	exeinto "${GAMEDIR}" || die "exeinto \${GAMEDIR}\" failed"
	if use amd64
	then
		newexe "${MY_PN}_64" "${PN}" || die "newexe \"${MY_PN}-amd64\" failed"
	fi
	if use x86
	then
		newexe "${MY_PN}_32" "${PN}" || die "newexe \"${MY_PN}-x86\" failed"
	fi

	# Make game wrapper
	games_make_wrapper "${PN}" "./${PN}" "${GAMEDIR}" || die "games_make_wrapper \"./${PN}\" failed"

	# Install icon and desktop file
	newicon "${MVDIR}/${ICONFILE}" "${PN}.png" || die "newicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Setting permissions
	prepgamesdirs
}

pkg_postinst() {
	echo ""
	games_pkg_postinst
}
