# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils autotools gnome2-utils fdo-mime

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gnome-mpv/gnome-mpv.git"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A simple GTK+ frontend for mpv"
HOMEPAGE="https://github.com/gnome-mpv/gnome-mpv"

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND=">=dev-libs/glib-2.44:2
	>=media-video/mpv-0.21.0[libmpv]
	x11-libs/gtk+:3"
RDEPEND="${DEPEND}"

src_prepare() {
	# see https://bugs.launchpad.net/intltool/+bug/1581124
	mkdir m4 || die
	sed -i '/^UPDATE_DESKTOP/d' Makefile.am || die
	sed -i '/^UPDATE_ICON/d' Makefile.am || die

	eapply_user
	eautoreconf
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update

	optfeature "Support for lua scripts" "media-video/mpv[lua]"
	optfeature "Support for watching YouTube streams" "net-misc/youtube-dl"
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	gnome2_schemas_update
}
