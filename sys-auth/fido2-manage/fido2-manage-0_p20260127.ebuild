# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_COMMIT="9be076ce4b5a878201d0bec9b23c459afdf53846"

DESCRIPTION="An open-source FIDO2.1 key management tool"
HOMEPAGE="https://github.com/token2/fido2-manage"

SRC_URI="https://github.com/token2/fido2-manage/archive/$MY_COMMIT.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/fido2-manage-${MY_COMMIT}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libcbor:=
	dev-libs/libfido2
	dev-libs/openssl:=
	virtual/zlib:=
"
RDEPEND="
	${DEPEND}
"

DOCS=( README.md TODO.md )

src_prepare(){
	cmake_src_prepare

	# Patch the script to replace ./fido2-manage.sh with fido2-manage
	find . -type f -name "*.py" -o -name "*.sh" -o -name "*.txt" -o -name "*.md" | \
		xargs sed -i 's|./fido2-manage\.sh|fido2-manage|g' || die

	# Update the fido2-manage.sh script to use the correct path for fido2-token2
	sed -i 's|FIDO2_TOKEN_CMD="/usr/local/bin/fido2-token2"|FIDO2_TOKEN_CMD="/usr/bin/fido2-token2"|g' \
		fido2-manage.sh || die
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
	newbin fido2-manage.sh fido2-manage

	# remove bundled libfido2
	rm -r "${D}/usr/include"  "${D}/usr/lib64" || die
}
