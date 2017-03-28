# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# generated with https://github.com/cardoe/cargo-ebuild
CRATES="
aho-corasick-0.5.3
dtoa-0.2.2
getopts-0.2.14
itoa-0.1.1
kernel32-sys-0.2.2
libc-0.2.21
memchr-0.1.11
num-traits-0.1.37
rand-0.3.15
regex-0.1.80
regex-syntax-0.3.9
serde-0.8.23
serde_json-0.8.6
shell32-sys-0.1.1
tempdir-0.3.5
thread-id-2.0.0
thread_local-0.2.7
user32-sys-0.2.0
utf8-ranges-0.1.3
winapi-0.2.8
winapi-build-0.1.1
"

inherit gnome2-utils cargo cmake-utils git-r3

DESCRIPTION="A port of Jagged Alliance 2 to SDL"
HOMEPAGE="https://ja2-stracciatella.github.io https://github.com/ja2-stracciatella/ja2-stracciatella"
EGIT_REPO_URI="https://github.com/ja2-stracciatella/ja2-stracciatella.git"
SRC_URI="$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"

LICENSE="SFI-SCLA"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/boost
	media-libs/libsdl2[X,sound,video]"

DEPEND="${RDEPEND}
	dev-util/cargo"

# for stable getopts-0.2.14
PATCHES=( "${FILESDIR}/Revert-Allow-options-with-a-single-dash.patch" )

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
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DEXTRA_DATA_DIR="${GAMES_DATADIR}"
		-DLOCAL_BOOST_LIB=OFF
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
