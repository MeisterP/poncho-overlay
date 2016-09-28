# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://github.com/hadess/iio-sensor-proxy"
SRC_URI="https://github.com/hadess/${PN}/releases/download/${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:*
	gnome-base/gnome-common
	virtual/libgudev"

DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	virtual/pkgconfig"
