# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils flag-o-matic

SLOT="2.6"

DESCRIPTION="Plugins for avidemux"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
IUSE="aac aften a52 alsa amr debug dts fontconfig fribidi jack lame libsamplerate cpu_flags_x86_mmx nvenc opengl opus oss pulseaudio qt5 vorbis truetype twolame xv xvid x264 x265 vdpau vpx"
KEYWORDS="~amd64"

MY_PN="${PN/-plugins/}"
MY_P="${MY_PN}_${PV}"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_PN}/${PV}/${MY_P}.tar.gz"

DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[vdpau?]
	~media-video/avidemux-${PV}:${SLOT}[opengl?,qt5?]
	>=dev-lang/spidermonkey-1.5-r2:0=
	dev-libs/libxml2:2
	media-libs/libpng:0=
	virtual/libiconv:0
	aac? (
		media-libs/faac:0
		media-libs/faad2:0
	)
	aften? ( media-libs/aften:0 )
	alsa? ( >=media-libs/alsa-lib-1.0.3b-r2:0 )
	amr? ( media-libs/opencore-amr:0 )
	dts? ( media-libs/libdca:0 )
	fontconfig? ( media-libs/fontconfig:1.0 )
	fribidi? ( dev-libs/fribidi:0 )
	jack? (
		media-sound/jack-audio-connection-kit:0
		libsamplerate? ( media-libs/libsamplerate:0 )
	)
	lame? ( media-sound/lame:0 )
	nvenc? ( media-video/nvidia_video_sdk:0 )
	opus? ( media-libs/opus:0 )
	oss? ( virtual/os-headers:0 )
	pulseaudio? ( media-sound/pulseaudio:0 )
	truetype? ( media-libs/freetype:2 )
	twolame? ( media-sound/twolame:0 )
	x264? ( media-libs/x264:0= )
	x265? ( >=media-libs/x265-1.9 )
	xv? (
		x11-libs/libX11:0
		x11-libs/libXext:0
		x11-libs/libXv:0
	)
	xvid? ( media-libs/xvid:0 )
	vorbis? ( media-libs/libvorbis:0 )
	vpx? ( media-libs/libvpx:0 )
"
RDEPEND="$DEPEND"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-2.6.4-optional-pulse.patch ${FILESDIR}/${PV}-disable-Qt5OpenGL.patch )

src_prepare() {
	default

	processes="buildPluginsCommon:avidemux_plugins
		buildPluginsCLI:avidemux_plugins"
	use qt5 && processes+=" buildPluginsQt5:avidemux_plugins"
}

src_configure() {
	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		local build="${process%%:*}"

		local PLUGIN_UI=$(echo ${build/buildPlugins/} | tr '[:lower:]' '[:upper:]')
		[[ ${PLUGIN_UI} == "QT5" ]] && PLUGIN_UI=QT4

		local mycmakeargs=(
			-DAVIDEMUX_SOURCE_DIR="${S}"
			-DPLUGIN_UI="${PLUGIN_UI}"
			-DENABLE_QT5="$(usex qt5)"
			-DFAAC="$(usex aac)"
			-DFAAD="$(usex aac)"
			-DALSA="$(usex alsa)"
			-DAFTEB="$(usex aften)"
			-DOPENCORE_AMRWB="$(usex amr)"
			-DOPENCORE_AMRNB="$(usex amr)"
			-DLIBDCA="$(usex dts)"
			-DFONTCONFIG="$(usex fontconfig)"
			-DJACK="$(usex jack)"
			-DLAME="$(usex lame)"
			-DNVENC="$(usex nvenc)"
			-DOPUS="$(usex opus)"
			-DOSS="$(usex oss)"
			-DPULSEAUDIOSIMPLE="$(usex pulseaudio)"
			-DFREETYPE2="$(usex truetype)"
			-DTWOLAME="$(usex twolame)"
			-DX264="$(usex x264)"
			-DX265="$(usex x265)"
			-DXVIDEO="$(usex xv)"
			-DXVID="$(usex xvid)"
			-DVDPAU="$(usex vdpau)"
			-DVORBIS="$(usex vorbis)"
			-DLIBVORBIS="$(usex vorbis)"
			-DVPX="$(usex vpx)"
		)

		if use debug ; then
			mycmakeargs+=" -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug -DADM_DEBUG=1"
		fi

		mkdir "${S}"/${build} || die "Can't create build folder."

		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_compile
	done
}

src_install() {
	for process in ${processes} ; do
		# cmake-utils_src_install doesn't respect BUILD_DIR
		# and there sometimes is a preinstall phase present.
		pushd "${S}/${process%%:*}" > /dev/null || die
			grep '^preinstall/fast' Makefile && emake DESTDIR="${D}" preinstall/fast
			grep '^install/fast' Makefile && emake DESTDIR="${D}" install/fast
		popd > /dev/null || die
	done
}
