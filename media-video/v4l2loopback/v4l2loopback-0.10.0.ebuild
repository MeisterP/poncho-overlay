# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-mod vcs-snapshot

DESCRIPTION="v4l2 loopback device which output is it's own input"
HOMEPAGE="https://github.com/umlaeute/v4l2loopback"
SRC_URI="https://github.com/umlaeute/v4l2loopback/archive/v${PV/_p*}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

CONFIG_CHECK="VIDEO_DEV"
MODULE_NAMES="v4l2loopback(video:)"
BUILD_TARGETS="all"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	linux-mod_pkg_setup
	export KERNELRELEASE=${KV_FULL}
}

src_compile() {
	linux-mod_src_compile

	if use examples; then
		cd "${S}"/examples
		emake
	fi
}

src_install() {
	linux-mod_src_install

	dosbin utils/v4l2loopback-ctl
	dodoc README.md NEWS
	dodoc -r doc
	if use examples; then
		dosbin examples/yuv4mpeg_to_v4l2
		docinto examples
		dodoc examples/{*.sh,*.c,Makefile,README}
	fi
}
