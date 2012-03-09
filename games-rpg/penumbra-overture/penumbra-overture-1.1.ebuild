# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit eutils games unpacker

DESCRIPTION="Scary first-person adventure game which focuses on story, immersion and puzzles"
HOMEPAGE="http://www.penumbra-overture.com/"
SRC_URI="${P//-/_}.sh"

# See eng_license.rtf.
LICENSE="as-is"

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/xz-utils"

RDEPEND="x11-misc/xdg-utils
	x86? (
		media-gfx/nvidia-cg-toolkit
		media-libs/freealut
		media-libs/libogg
		media-libs/libsdl
		media-libs/libvorbis
		>=media-libs/openal-1.5
		media-libs/sdl-image
		media-libs/sdl-ttf
		virtual/glu
		virtual/opengl
		x11-libs/fltk:1.1 )
	amd64? (
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs
		app-emulation/emul-linux-x86-xlibs )"

S="${WORKDIR}/PenumbraOverture"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  ${HOMEPAGE}"
	einfo
	einfo "Then move it to:"
	einfo "  ${DISTDIR}"
	einfo
}

src_unpack() {
	# Until bug 319059 is fixed...
	unpack_makeself ${A} 11193 dd

	ln -snf subarch subarch.tar.lzma || die
	ln -snf instarchive_all instarchive_all.tar.lzma || die
	unpack ./subarch.tar.lzma ./instarchive_all.tar.lzma
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"

	newexe penumbra.bin "${PN}" || die
	newicon penumbra.png "${PN}.png" || die
	doins -r *.cfg billboards config core fonts graphics lights maps models music particles sounds textures || die
	dodoc CHANGELOG.txt eng_license.rtf Manual.pdf README.donation README.linux || die

	# Use xdg-open instead of crappy openurl.sh script.
	ln -s /usr/bin/xdg-open "${D}${dir}/openurl.sh" || die

	if use amd64 ; then
		exeinto "${dir}/lib"
		doexe lib/libCg*.so* lib/libfltk.so* || die
	fi

	games_make_wrapper "${PN}" "./${PN}" "${dir}" "${dir}/lib" || die
	make_desktop_entry "${PN}" "Penumbra: Overture" || die

	prepgamesdirs
}
