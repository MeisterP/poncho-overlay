# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson xdg

#MY_COMMIT="a609dd033bb1ba6e29415e89c1876c6545f731c1"

DESCRIPTION="A simple GTK+ frontend for mpv"
HOMEPAGE="https://celluloid-player.github.io/"
SRC_URI="https://github.com/celluloid-player/celluloid/releases/download/v${PV}/${P}.tar.xz"
#SRC_URI="https://github.com/celluloid-player/celluloid/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-libs/glib-2.66
	gui-libs/gtk:4
	>=gui-libs/libadwaita-1.2.0
	>=media-video/mpv-0.32[libmpv]
	media-libs/libepoxy"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

#S="${WORKDIR}/celluloid-${MY_COMMIT}"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}