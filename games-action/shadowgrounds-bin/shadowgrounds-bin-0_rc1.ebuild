# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit games eutils

DESCRIPTION="An epic action experience combining modern technology with addictive playability"
HOMEPAGE="http://shadowgroundsgame.com/"
SRC_URI="shadowgroundsUpdate1.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="alsa"
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=sys-libs/glibc-2.4
	>=sys-devel/gcc-4.3.0
	x86? (
		gnome-base/libglade
		=media-libs/libsdl-1.2*
		=media-libs/sdl-image-1.2*
		=media-libs/sdl-ttf-2.0*
		virtual/ffmpeg
		media-libs/jpeg:62
		media-libs/libogg
		=media-libs/openal-1*
		media-libs/libpng:1.2
		media-libs/libvorbis
	)
	amd64? (
		app-emulation/emul-linux-x86-gtklibs
		app-emulation/emul-linux-x86-sdl
		app-emulation/emul-linux-x86-soundlibs[pulseaudio]
	)
	media-sound/pulseaudio
	alsa? ( media-plugins/alsa-plugins[pulseaudio] )"

S=${WORKDIR}

d="${GAMES_PREFIX_OPT}/${PN}"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"
QA_TEXTRELS_amd64=${QA_TEXTRELS_x86}

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unzip -q "${DISTDIR}/${A}"
	rm lib*/lib{gcc_s,m,rt,selinux}.so.?

	# remove bundled libraries
	rm "${S}/lib32/libGLEW.so.1.5"
	rm "${S}/lib32/libasound_module_pcm_pulse.so"
	rm "${S}/lib32/libasound.so.2"
	rm "${S}/lib32/libavformat.so.52"
	rm "${S}/lib32/libboost_filesystem.so.1.35.0"
	rm "${S}/lib32/libboost_regex.so.1.35.0"
	rm "${S}/lib32/libboost_system.so.1.35.0"
	rm "${S}/lib32/libdirect-1.0.so.0"
	rm "${S}/lib32/libexpat.so.1"
	rm "${S}/lib32/libFLAC.so.8"
	rm "${S}/lib32/libfusion-1.0.so.0"
	rm "${S}/lib32/libgdbm.so.3"
	rm "${S}/lib32/libGLEW.so.1.5"
	rm "${S}/lib32/libgmodule-2.0.so.0"
	rm "${S}/lib32/libgomp.so.1"
	rm "${S}/lib32/libICE.so.6"
	rm "${S}/lib32/libicudata.so.38"
	rm "${S}/lib32/libicui18n.so.38"
	rm "${S}/lib32/libicuuc.so.38"
	rm "${S}/lib32/libjpeg.so.62"
	rm "${S}/lib32/libmikmod.so.2"
	rm "${S}/lib32/libNxCharacter.so"
	rm "${S}/lib32/libNxCooking.so"
	rm "${S}/lib32/libogg.so.0"
	rm "${S}/lib32/libopenal.so.1"
	rm "${S}/lib32/libpcre.so.3"
	rm "${S}/lib32/libpng12.so.0"
	rm "${S}/lib32/libSDL-1.2.so.0"
	rm "${S}/lib32/libSDL_image-1.2.so.0"
	rm "${S}/lib32/libSDL_sound-1.0.so.1"
	rm "${S}/lib32/libSDL_ttf-2.0.so.0"
	rm "${S}/lib32/libsmpeg-0.4.so.0"
	rm "${S}/lib32/libSM.so.6"
	rm "${S}/lib32/libspeex.so.1"
	rm "${S}/lib32/libstdc++.so.6"
	rm "${S}/lib32/libtiff.so.4"
	rm "${S}/lib32/libvga.so.1"
	rm "${S}/lib32/libvorbisfile.so.3"
	rm "${S}/lib32/libvorbis.so.0"
	rm "${S}/lib32/libX11.so.6"
	rm "${S}/lib32/libx86.so.1"
	rm "${S}/lib32/libXau.so.6"
	rm "${S}/lib32/libxcb-render.so.0"
	rm "${S}/lib32/libxcb-render-util.so.0"
	rm "${S}/lib32/libxcb.so.1"
	rm "${S}/lib32/libxcb-xlib.so.0"
	rm "${S}/lib32/libXcomposite.so.1"
	rm "${S}/lib32/libXcursor.so.1"
	rm "${S}/lib32/libXdamage.so.1"
	rm "${S}/lib32/libXdmcp.so.6"
	rm "${S}/lib32/libXext.so.6"
	rm "${S}/lib32/libXfixes.so.3"
	rm "${S}/lib32/libXinerama.so.1"
	rm "${S}/lib32/libXi.so.6"
	rm "${S}/lib32/libxml2.so.2"
	rm "${S}/lib32/libXmu.so.6"
	rm "${S}/lib32/libXrender.so.1"
	rm "${S}/lib32/libXt.so.6"
	rm "${S}/lib32/libz.so.1"
}

src_install() {
	local b bb

	doicon Shadowgrounds.xpm || die
	for b in bin launcher ; do
		bb="shadowgrounds-${b}"
		exeinto ${d}
		newexe ${bb} ${bb} || die
		games_make_wrapper ${bb} "./${bb}" "${d}" || die
		make_desktop_entry ${bb} "Shadowgrounds ${b}" Shadowgrounds
	done

	exeinto ${d}/lib32
	doexe lib32/* || die

	insinto ${d}
	doins -r Config data Profiles *.fbz *.glade *-logo.png || die

	prepgamesdirs
}
