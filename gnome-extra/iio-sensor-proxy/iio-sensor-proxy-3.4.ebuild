# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit udev meson

DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://gitlab.freedesktop.org/hadess/iio-sensor-proxy"
SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/glib:*
	gnome-base/gnome-common
	>=dev-libs/libgudev-237
	virtual/udev"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
