# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit eutils gnome2-utils fdo-mime games qmake-utils

DESCRIPTION="Multimedia interpreter for TADS text adventures"
HOMEPAGE="http://qtads.sourceforge.net"
SRC_URI="mirror://sourceforge/qtads/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4 qt5"
REQUIRED_USE="^^ ( qt4 qt5 )"

# Note that for sdl-sound, we need the "mp3", not the "mpeg" USE flag. "mpeg"
# uses the SMPEG lib for decoding, which plays some MP3s at double speed. "mp3"
# uses SDL_sound's internal MPGLIB, which doesn't have that problem. It's OK
# if both "mp3" as well as "mpeg" are enabled, because SDL_sound tries MPGLIB
# first, and only if that fails will it use SMPEG.
RDEPEND="qt4? ( dev-qt/qtgui:4 )
	qt5? ( dev-qt/qtgui:5 )
	media-libs/libsdl[sound]
	media-libs/sdl-mixer[midi,vorbis]
	media-libs/sdl-sound[mp3]
	x11-misc/shared-mime-info"
DEPEND="${RDEPEND}"

DOCS="AUTHORS HTML_TADS_LICENSE NEWS README"

src_configure() {
	use qt4 && eqmake4 qtads.pro -after CONFIG-=silent
	use qt5 && eqmake5 qtads.pro -after CONFIG-=silent
}

src_install() {
	dogamesbin qtads
	dodoc ${DOCS}
	insinto /usr
	doins -r "share"
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
