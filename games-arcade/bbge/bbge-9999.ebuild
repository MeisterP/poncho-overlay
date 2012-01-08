# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
EHG_REPO_URI="http://hg.icculus.org/icculus/aquaria"
EHG_PROJECT="aquaria"

inherit flag-o-matic games cmake-utils mercurial

DESCRIPTION="The Bit-Blot Game Engine, used by Aquaria"
HOMEPAGE="http://www.bit-blot.com/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND=">=dev-libs/tinyxml-2.6.1-r1[stl]
	media-libs/freetype:2
	media-libs/ftgl
	media-libs/glpng
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/opengl"

DEPEND="${RDEPEND}"

S="${WORKDIR}/aquaria"

src_prepare() {
	# Remove bundled stuff to ensure it's not used.
	rm -r BBGE/{GL,glext} || die

	# Remove bundled sources.
	# Don't build Aquaria.
	sed -i \
		-e '/glpng/d' -e '/tinyxml/d' \
		-e '/TARGET_LINK_LIBRARIES/d' \
		-e '/ADD_EXECUTABLE[(]/,/[)]/d' \
		CMakeLists.txt || die

	# Set the data prefix directory.
	echo "ADD_DEFINITIONS(-DBBGE_DATA_PREFIX=\"${GAMES_DATADIR}\")" >> CMakeLists.txt || die

	# Always build shared.
	echo 'ADD_LIBRARY(BBGE SHARED ${BBGE_SRCS})' >> CMakeLists.txt || die

	# Optionally build static.
	if use static-libs; then
		echo 'ADD_LIBRARY(BBGE_Static STATIC ${BBGE_SRCS})' >> CMakeLists.txt || die
		echo 'SET_TARGET_PROPERTIES(BBGE_Static PROPERTIES OUTPUT_NAME BBGE)' >> CMakeLists.txt || die
	fi

	# Resolve symbols now, not later.
	echo 'TARGET_LINK_LIBRARIES(BBGE ftgl glpng openal SDL tinyxml vorbisfile z)' >> CMakeLists.txt || die

	# Use system headers.
	ln -snf ../ExternalLibs/glfont2 BBGE/glfont2 || die
	sed -i 's:\.\./ExternalLibs/::' BBGE/*.{cpp,h} || die
	sed -i -r 's:["<](gl[a-z]*\.h)[">]:<GL/\1>:' BBGE/Base.h BBGE/Texture.cpp || die
	sed -i -e 's:"FTGL\.h":<FTGL/ftgl.h>:' -e '/FTGLTextureFont\.h/d' BBGE/TTFFont.h || die
}

src_configure() {
	# The bundled glpng.h defines this.
	append-cppflags -DPNG_LUMINANCEALPHA=-4

	append-cppflags -I/usr/include/freetype2
	append-ldflags -Wl,-z -Wl,defs
	cmake-utils_src_configure
}

src_install() {
	dolib "${CMAKE_BUILD_DIR}"/libBBGE.* || die

	insinto /usr/include/BBGE
	doins BBGE/*.h || die

	insinto /usr/include/BBGE/glfont2
	doins BBGE/glfont2/*.h || die
}
