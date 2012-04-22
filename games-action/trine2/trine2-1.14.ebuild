# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
inherit eutils games

MY_PN="Trine 2"

DESCRIPTION="A sidescrolling game of action, puzzles and platforming"
HOMEPAGE="http://www.trine2.com/"
SRC_URI="${PN}_linux_installer.run"
LICENSE=""

SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

IUSE="+bundled-libs launcher"
RESTRICT="fetch strip"

DEPEND="app-arch/tar"

RDEPEND="amd64? (
	  app-emulation/emul-linux-x86-baselibs
	  app-emulation/emul-linux-x86-opengl
	  app-emulation/emul-linux-x86-sdl
	  app-emulation/emul-linux-x86-soundlibs
	  app-emulation/emul-linux-x86-xlibs 
	  launcher? (
	    app-emulation/emul-linux-x86-gtklibs ) )
	  
	x86? (
	  dev-libs/glib
	  media-libs/freetype
	  media-libs/libogg
	  media-libs/libvorbis
	  media-libs/openal
	  sys-libs/zlib
	  virtual/glu
	  virtual/opengl
	  !bundled-libs? (
	    media-gfx/libphysx
	    >=media-libs/libsdl-1.3
	    media-gfx/nvidia-cg-toolkit )
	  launcher? (
	    dev-libs/atk
	    dev-libs/glib
	    media-libs/fontconfig
	    sys-libs/glibc
	    x11-libs/gdk-pixbuf
	    x11-libs/gtk+
	    x11-libs/libSM
	    x11-libs/libX11
	    x11-libs/libXinerama
	    x11-libs/libXxf86vm
	    x11-libs/pango ) )"

S="${WORKDIR}"
GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

# Downloaded file is a self-extracting archive. After this line starts the data we need:
DATA_MARKER="THIS_IS_THE_LAST_SCRIPT_LINE_ARCHIVE_DATA_FOLLOWS"

pkg_nofetch() {
	einfo ""
	einfo "Please download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

src_setup() {
	if ( use "amd64" && ! use "bundled-libs" )
	then
	  einfo ""
	  einfo "You are using an amd64 system and selected"
	  einfo "to not install the bundled-libs."
	  einfo ""
	  einfo "Actualy there isn't any \"emul-linux\" package providing"
	  einfo "needed x86 libs, so we'll keep bundled ones."
	  einfo ""
	fi
}

src_unpack() {
	local archive="${DISTDIR}/${A}"
	local data_marker_line="$(grep --binary-file=text -h -n -m 1 -F -e "${DATA_MARKER}" "${archive}" | cut -d':' -f1)"

	if [[ "${?}" == "0" && "${data_marker_line}" =~ ^[0-9]+$ ]]
	then
	  echo ">>> Unpacking ${A} to ${PWD}"
	  ( tail --lines=+$(( ${data_marker_line} + 1 )) "${archive}" | tar xz ) || die "unpacking \"${archive}\" failed"
	else
	  die "unpacking \"${archive}\" failed"
	fi
}

src_install() {
	# Install data files:
	insinto "${GAMEDIR}" || die "insinto \"${GAMEDIR}\" failed"
	doins -r data* || die "doins \"data\" failed"
	
	# Install executables and libraries:
	exeinto "${GAMEDIR}" || die "exeinto \"${GAMEDIR}\" failed"
	newexe "bin/trine2_linux_32bit" "${PN}" || die "newexe \"${PN}\" failed"
	use launcher && ( newexe "bin/trine2_linux_launcher_32bit" "${PN}-launcher" || die "newexe \"${PN}-launcher\" failed" )
	
	exeinto "${GAMEDIR}/lib" || die "exeinto \"${GAMEDIR}/lib\" failed"
	( use "amd64" || use "bundled-libs" ) && ( find lib*/lib* -type f -iname '*.so*' -exec doexe '{}' \+ || die "doins bundled libs failed" )

	# Make game wrapper:
	games_make_wrapper "${PN}" "$( usex "launcher" "./${PN}-launcher &> /dev/null" "./${PN} &> /dev/null" )" "${GAMEDIR}" "$( ( use "amd64" || use "bundled-libs" ) && echo "${GAMEDIR}/lib" )" || die "games_make_wrapper \"${PN}\" failed"

	# Install icon and desktop files:
	doicon "${PN}.png" || die "doicon \"${PN}.png\" failed"
	make_desktop_entry "${PN}" "${MY_PN}" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"
	
	# Install docs:
	dodoc "KNOWN_LINUX_ISSUES" || die "dodoc failed"

	# Setting permissions
	prepgamesdirs
}

pkg_postinst() {
	echo ""
	games_pkg_postinst

	einfo "${MY_PN} savegames and configurations are stored in:"
	einfo "   \${HOME}/.frozenbyte/${MY_PN//\ /}"
	echo ""
}
