# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg

MY_COMMIT="e3f67f9cd0680f99dcf3e30b2f44523d66426ccd"

DESCRIPTION="A simple GTK+ frontend for mpv"
HOMEPAGE="https://celluloid-player.github.io/"
#SRC_URI="https://github.com/celluloid-player/celluloid/releases/download/v${PV}/${P}.tar.xz"
SRC_URI="https://github.com/celluloid-player/celluloid/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/glib-2.66
	gui-libs/gtk:4
	gui-libs/libadwaita
	>=media-video/mpv-0.32[libmpv]
	media-libs/libepoxy"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

S="${WORKDIR}/celluloid-${MY_COMMIT}"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
