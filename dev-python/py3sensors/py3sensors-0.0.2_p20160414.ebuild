# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

COMMIT=0cf96f4e2cfe

DESCRIPTION="Python bindings for libsensors via ctypes."
HOMEPAGE="https://bitbucket.org/gleb_zhulik/${PN}"
SRC_URI="https://bitbucket.org/gleb_zhulik/${PN}/get/${COMMIT}.zip"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sys-apps/lm_sensors"

S="${WORKDIR}/gleb_zhulik-${PN}-${COMMIT}"
