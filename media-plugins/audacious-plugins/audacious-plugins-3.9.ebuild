# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PLOCALES="ar be bg ca cmn cs da de el en_GB es es_AR es_MX et eu fa_IR fi fr
	gl hu id_ID it ja ko ky lt lv ms nl pl pt_BR pt_PT ru si sk sr
	sr_RS sv ta tr uk zh_CN zh_TW"
PLOCALE_BACKUP="en_GB"

inherit l10n

DESCRIPTION="Plugins for Audacious music player"
HOMEPAGE="http://audacious-media-player.org/"
SRC_URI="http://distfiles.audacious-media-player.org/${P}.tar.bz2"

# Generally BSD-2. but GTK+/Qt5 skins: GPL-3, mostly: GPL-2+, some: LGPL-2.1+
LICENSE="BSD-2 GPL-2+ GPL-3 LGPL-2.1+ libnotify? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aac alsa bs2b cdda cue ffmpeg +filewriter flac gnome +gtk http jack lame
	libav libnotify libsamplerate lirc midi mms modplug mp3 pulseaudio qt5
	scrobbler sdl sid sndfile soxr spectrum vorbis wavpack"
REQUIRED_USE="	|| ( gtk qt5 )
	libnotify? ( || ( gtk qt5 ) )
	spectrum? ( || ( gtk qt5 ) )"

COMMON_DEPEND=">=dev-libs/dbus-glib-0.60
	dev-libs/libxml2:2
	~media-sound/audacious-${PVR}[gtk=,qt5=]
	>=sys-apps/dbus-0.6.0
	>=sys-devel/gcc-4.7.0:*
	x11-libs/libXcomposite
	x11-libs/libXrender
	aac? ( >=media-libs/faad2-2.7 )
	alsa? ( >=media-libs/alsa-lib-1.0.16 )
	bs2b? ( >=media-libs/libbs2b-3.0.0 )
	cdda? ( >=media-libs/libcddb-1.2.1
		>=dev-libs/libcdio-0.70
		>=dev-libs/libcdio-paranoia-0.70 )
	cue? ( media-libs/libcue )
	ffmpeg? ( libav? ( media-video/libav:0= )
		!libav? ( media-video/ffmpeg:0= ) )
	flac? ( >=media-libs/libvorbis-1.0
		>=media-libs/flac-1.2.1-r1 )
	gtk? ( x11-libs/gtk+:2 )
	http? ( >=net-libs/neon-0.27 )
	jack? ( >=media-libs/bio2jack-0.4
		virtual/jack )
	lame? ( media-sound/lame )
	libnotify? ( >=x11-libs/gdk-pixbuf-2.26
		>=x11-libs/libnotify-0.7 )
	libsamplerate? ( media-libs/libsamplerate )
	lirc? ( app-misc/lirc )
	midi? ( >=media-sound/fluidsynth-1.0.6 )
	mms? ( >=media-libs/libmms-0.3 )
	modplug? ( media-libs/libmodplug )
	mp3? ( >=media-sound/mpg123-1.12.1 )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.5 )
	qt5? ( dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtwidgets:5
		spectrum? ( dev-qt/qtopengl:5 ) )
	scrobbler? ( >=net-misc/curl-7.9.7 )
	sdl? ( || ( >=media-libs/libsdl-1.2.11[sound]
			>=media-libs/libsdl2-2.0[sound] ) )
	sid? ( >=media-libs/libsidplayfp-1.0.0 )
	sndfile? ( >=media-libs/libsndfile-1.0.17-r1 )
	soxr? ( media-libs/soxr )
	spectrum? ( virtual/opengl
		qt5? ( dev-qt/qtopengl:5 ) )
	vorbis? ( >=media-libs/libogg-1.1.3
		>=media-libs/libvorbis-1.2.0 )
	wavpack? ( >=media-sound/wavpack-4.50.1-r1 )"
DEPEND="${COMMON_DEPEND}
	|| ( >=dev-libs/glib-2.32.2
		dev-util/gdbus-codegen )
	sys-devel/gettext
	virtual/pkgconfig"
RDEPEND=${COMMON_DEPEND}

RESTRICT="mirror"

src_prepare() {
	eapply "${FILESDIR}/${PN}-3.8-qtglspectrum-include-glu.patch"
	l10n_for_each_disabled_locale_do remove_locales
	eapply_user
}

src_configure() {
	local ffmpeg_conf=""
	use ffmpeg && ffmpeg_conf="--with-ffmpeg=ffmpeg"
	use libav && ffmpeg_conf="--with-ffmpeg=libav"

	local spectrum_conf=""
	if use spectrum ; then
		use gtk && spectrum_conf="${spectrum_conf} --enable-glspectrum"
		use qt5 && spectrum_conf="${spectrum_conf} --enable-qtglspectrum"
	fi

	# coreaudio and mac-media-keys are for MacOSX / Darwin
	# ampache browser is depended on another library,
	# see https://github.com/ampache-browser/ampache_browser
	econf \
		--disable-ampache \
		--disable-coreaudio \
		--disable-mac-media-keys \
		$(use_enable aac) \
		$(use_enable alsa) \
		$(use_enable bs2b) \
		$(use_enable cdda cdaudio) \
		$(use_enable cue) \
		${ffmpeg_conf} \
		$(use_enable gnome gnomeshortcuts) \
		$(use_enable gtk aosd) \
		$(use_enable gtk) \
		$(use_enable gtk hotkey) \
		$(use_enable jack) \
		$(use_enable lame filewriter_mp3) \
		$(use_enable libnotify notify) \
		$(use_enable libsamplerate resample) \
		$(use_enable lirc) \
		$(use_enable midi amidiplug) \
		$(use_enable mms) \
		$(use_enable modplug) \
		$(use_enable midi amidiplug) \
		$(use_enable pulseaudio pulse) \
		$(use_enable qt5 qt) \
		$(use_enable qt5 qtaudio) \
		$(use_enable scrobbler scrobbler2) \
		$(use_enable sdl sdlout) \
		$(use_enable sid) \
		$(use_enable sndfile) \
		$(use_enable soxr) \
		${spectrum_conf} \
		$(use_enable vorbis) \
		$(use_enable wavpack)
}

remove_locales() {
	sed -i "s/${1}.po//" po/Makefile
}
