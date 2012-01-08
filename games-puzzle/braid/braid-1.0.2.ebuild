# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit games

DESCRIPTION="Platform game where you manipulate flow of time"
HOMEPAGE="http://braid-game.com"
SRC_URI="${PN}-linux-build${PV/1.0./}.run.bin"

LICENSE="Arphic CCPL-Attribution-ShareAlike-NonCommercial-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

#IUSE="video_cards_nvidia"
IUSE=""
RESTRICT="strip fetch"

DEPEND="app-arch/unzip"
RDEPEND="media-libs/libsdl[audio,joystick,video]
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXdmcp
	x11-libs/libXext
	virtual/opengl
	media-gfx/nvidia-cg-toolkit"
#	video_cards_nvidia? ( media-gfx/nvidia-cg-toolkit )"

S=${WORKDIR}/data

pkg_nofetch() {
	echo
	elog "Download ${SRC_URI} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${A}"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

	doins -r gamedata/data || die "doins failed"
	if use x86; then doexe x86/"${PN}" || die "doexe failed"; fi
	if use amd64; then doexe amd64/"${PN}" || die "doexe failed"; fi

	doicon gamedata/"${PN}.png" || die "doicon failed"

	dodoc gamedata/README-linux.txt || die "dodoc failed"

	games_make_wrapper "${PN}" "./${PN}" "${dir}"
	make_desktop_entry "${PN}" "Braid" "${PN}"

	prepgamesdirs
}
