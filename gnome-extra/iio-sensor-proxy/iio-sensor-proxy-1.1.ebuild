# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="IIO sensors to D-Bus proxy"
HOMEPAGE="https://github.com/hadess/iio-sensor-proxy"
SRC_URI="https://github.com/hadess/iio-sensor-proxy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/glib:*
	gnome-base/gnome-common
	virtual/libgudev"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	virtual/pkgconfig"

src_prepare() {
	eautoreconf
}
