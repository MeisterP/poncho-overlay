# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="dtoa-0.4.2
	getopts-0.2.15
	itoa-0.3.4
	libc-0.2.33
	num-traits-0.1.40
	quote-0.3.15
	serde-1.0.18
	serde_derive-1.0.18
	serde_derive_internals-0.16.0
	serde_json-1.0.5
	syn-0.11.11
	synom-0.11.3
	unicode-xid-0.0.4"

inherit gnome2-utils flag-o-matic cargo cmake-utils

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" $(cargo_crate_uris ${CRATES})"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="launcher"

RDEPEND="dev-libs/boost:=
	media-libs/libsdl2[X,sound,video]
	launcher? ( x11-libs/fltk )"

DEPEND="${RDEPEND}
	dev-libs/rapidjson
	dev-util/cargo"

PATCHES=( "${FILESDIR}/only-use-profile.release.patch" )

DOCS=( README.md changes.md contributors.txt )

GAMES_DATADIR="/usr/share/ja2"

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:g" \
		rust/src/stracciatella.rs || die

	mkdir "${PORTAGE_BUILDDIR}/homedir/.cargo" || die
	cp "${WORKDIR}/cargo_home/config" "${PORTAGE_BUILDDIR}/homedir/.cargo/config" || die
}

src_configure() {
	append-cppflags "-I/usr/include/fltk"
	CMAKE_BUILD_TYPE=RelWithDebInfo

	local mycmakeargs=(
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DINSTALL_LIB_DIR="/usr/$(get_libdir)"
		-DBUILD_LAUNCHER=$(usex launcher ON OFF)
		-DLOCAL_SDL_LIB=OFF
		-DLOCAL_BOOST_LIB=OFF
		-DLOCAL_RAPIDJSON_LIB=OFF
		-DLOCAL_GTEST_LIB=OFF
		-DWITH_UNITTESTS=OFF
		-DWITH_FIXMES=OFF
		-DWITH_MAEMO=OFF
	)

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	keepdir "${GAMES_DATADIR}/data"
}

pkg_postinst() {
	gnome2_icon_cache_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You need to copy all files from the Data directory of"
		elog "Jagged Alliance 2 installation to"
		elog "${GAMES_DATADIR}/data"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
