# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake udev linux-info

MY_COMMIT="4fc6a4e0d905dcc2a7bfee70232a0398e9e4b45d"

DESCRIPTION="Forked from libfido2 to provide a FIDO2.1 key management tool"
HOMEPAGE="https://github.com/token2/fido2-manage"

SRC_URI="https://github.com/token2/fido2-manage/archive/$MY_COMMIT.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fido2-manage-${MY_COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libcbor:=
	dev-libs/openssl:=
	sys-libs/zlib:=
	virtual/libudev:=
"
RDEPEND="
	${DEPEND}
	acct-group/plugdev
	!dev-libs/libfido2
"

pkg_pretend() {
	CONFIG_CHECK="
		~USB_HID
		~HIDRAW
	"

	check_extra_config
}

src_prepare(){
	cmake_src_prepare
	sed -i -e "s:/usr/local/bin/fido2-token2:/usr/bin/fido2-token2:" fido2-manage.sh || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_EXAMPLES=OFF
		-DBUILD_MANPAGES=OFF
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_STATIC_LIBS=OFF
		-DBUILD_TOOLS=ON
		-DFUZZ=OFF
		-DUSE_HIDAPI=OFF
		-DUSE_PCSC=OFF
		-DUSE_WINHELLO=OFF
		-DNFC_LINUX=OFF
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	dobin fido2-manage.sh

	udev_newrules udev/70-u2f.rules 70-libfido2-u2f.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
