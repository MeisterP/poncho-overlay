# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="getopts-0.2.15
	libc-0.2.21
	serde-0.8.23
	serde_json-0.8.6
	dtoa-0.2.2
	itoa-0.1.1
	num-traits-0.1.37"

inherit gnome2-utils cargo cmake-utils git-r3

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
EGIT_REPO_URI="https://github.com/ja2-stracciatella/ja2-stracciatella.git"
SRC_URI="$(cargo_crate_uris ${CRATES})"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/boost
	media-libs/libsdl2[X,sound,video]"

DEPEND="${RDEPEND}
	dev-libs/rapidjson
	dev-util/cargo"

PATCHES=( "${FILESDIR}/0001-use-stable-version-of-getopts.patch"
	"${FILESDIR}/0002-make-INSTALL_LIB_DIR-configurable.patch"
	"${FILESDIR}/0003-only-use-profile.release.patch" )

DOCS=( README.md changes.md contributors.txt )

GAMES_DATADIR="/usr/share/ja2"

src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
}

src_prepare() {
	default
	sed -i -e "s:/some/place/where/the/data/is:${GAMES_DATADIR}:g" \
		rust/src/stracciatella.rs || die

	mkdir "${PORTAGE_BUILDDIR}/homedir/.cargo" || die
	cp "${WORKDIR}/cargo_home/config" "${PORTAGE_BUILDDIR}/homedir/.cargo/config" || die
}

src_configure() {
	CMAKE_BUILD_TYPE=RelWithDebInfo

	local mycmakeargs=(
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DINSTALL_LIB_DIR="/usr/$(get_libdir)"
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

pkg_preinst() {
	gnome2_icon_savelist
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
