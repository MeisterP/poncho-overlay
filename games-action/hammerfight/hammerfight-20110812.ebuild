# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils games

DESCRIPTION="2D battles of flying machines equipped with various slashing, piercing and blunt weaponry"
HOMEPAGE="http://www.koshutin.com/"
SRC_URI="hf-linux-${PV:4}${PV:0:4}-bin"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="linguas_ru"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[audio,joystick,video]
	media-libs/openal"

RESTRICT="fetch"

S="${WORKDIR}"/data
dir="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	ewarn
	ewarn "Place ${A} to ${DISTDIR}"
	ewarn
}

src_unpack() {
	unzip -q "${DISTDIR}"/${A}
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {

	if use linguas_ru ; then
		einfo "Russian is chosen for primary language"
		mv Data/Dialogs/{russian,english}.seria
	fi

	insinto "${dir}"
	doins -r Data Media Objects Saves media.script strings.txt Config.ini \
		|| die "doins failed"

	if use amd64 ; then
		local exe=Hammerfight-amd64
	fi
	if use x86 ; then
		local exe=Hammerfight-x86
	fi
	exeinto "${dir}"
	doexe ${exe} || die "doexe failed"

	games_make_wrapper ${PN} ./${exe} "${dir}" "${dir}"
	doicon ${PN}.png
	make_desktop_entry ${PN} "Hammerfight" ${PN}

	prepgamesdirs
}
