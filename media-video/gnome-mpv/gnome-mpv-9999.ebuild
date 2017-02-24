# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit gnome2-utils fdo-mime

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

RDEPEND=">=dev-libs/glib-2.44:2
	>=media-video/mpv-0.21.0[libmpv]
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	>=dev-util/meson-0.37.0"

src_configure(){
	# Not a normal configure
	# --buildtype=plain needed for honoring CFLAGS/CXXFLAGS and not
	# defaulting to debug

	meson --prefix="${EPREFIX}/usr" \
		--libdir="$(get_libdir)" \
		--buildtype=plain mesonbuild || die
}

src_compile() {
	# We cannot use 'make' as it won't allow us to build verbosely
	ninja -v -C mesonbuild || die
}

src_install(){
	DESTDIR=${D} ninja -v -C mesonbuild install || die
	dodoc README.md AUTHORS
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
