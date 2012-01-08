# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EHG_REPO_URI="http://hg.icculus.org/icculus/aquaria"

inherit eutils flag-o-matic games cmake-utils mercurial

DESCRIPTION="A 2D scroller set in a massive ocean world"
HOMEPAGE="http://www.bit-blot.com/aquaria/"
SRC_URI="aquaria-lnx-humble-bundle.mojo.run"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
RESTRICT="fetch"

RDEPEND="dev-lang/lua
	>=dev-libs/tinyxml-2.6.1-r1[stl]
	games-arcade/bbge
	media-libs/glpng
	media-libs/libsdl"

DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

pkg_nofetch() {
	echo
	elog "Download ${A} from ${HOMEPAGE} and place it in ${DISTDIR}"
	echo
}

src_unpack() {
	# self unpacking zip archive; unzip warns about the exe stuff
	local a="${DISTDIR}/${A}"
	echo ">>> Unpacking ${a} to ${PWD}"
	unzip -q "${a}"
	[ $? -gt 1 ] && die "unpacking failed"

	mercurial_src_unpack
}

src_prepare() {
	# Fix include paths.
	sed -i \
		-e "s:\.\./ExternalLibs/glpng:GL/glpng:" \
		-e "s:\.\./ExternalLibs/::" \
		-e "s:\.\./BBGE/:BBGE/:" \
		Aquaria/*.{cpp,h} || die

	# Only build game sources.
	rm -r BBGE/ || die
	sed -i "/ADD_EXECUTABLE[(]/,/[)]/d" CMakeLists.txt || die
	echo 'ADD_EXECUTABLE(aquaria ${AQUARIA_SRCS})' >> CMakeLists.txt || die

	# Redefine libraries to link against.
	sed -i "/TARGET_LINK_LIBRARIES/d" CMakeLists.txt || die
	echo "TARGET_LINK_LIBRARIES(aquaria BBGE glpng lua pthread SDL tinyxml)" >> CMakeLists.txt || die
}

src_configure() {
	append-cppflags -I/usr/include/BBGE -I/usr/include/freetype2
	cmake-utils_src_configure
}

src_install() {
	dogamesbin "${CMAKE_BUILD_DIR}/${PN}" || die

	cd ../data || die
	insinto "${GAMES_DATADIR}/Aquaria"
	doins -r *.xml */ || die
	doins -r "${S}"/game_scripts/* || die

	dodoc README-linux.txt || die
	dohtml -r docs/* || die

	doicon "${PN}.png" || die
	make_desktop_entry "${PN}" "Aquaria" || die

	prepgamesdirs
}
