inherit eutils games

DESCRIPTION="Demo of an award winning physics-based platform game where you run and jump through a world made of paper"
HOMEPAGE="http://www.andyetitmoves.net"

MY_PN="AndYetItMoves"

if [[ ${ARCH} = "x86" ]]; then
	MY_ARCH="i386"
else
	MY_ARCH="x86_64"
fi

#SRC_URI="http://www.andyetitmoves.net/demo/${MY_PN}-${PV}_${MY_ARCH}.tar.gz"
SRC_URI="${MY_PN}-${PV}_${MY_ARCH}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=sys-devel/gcc-3.4
	dev-libs/expat
	media-libs/aalib
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	virtual/jpeg
	media-libs/libpng
	media-libs/libsdl
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/sdl-image
	media-libs/tiff
	sys-libs/glibc
	sys-libs/ncurses
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	"
DEPEND=""

S=${WORKDIR}/${MY_PN}

QA_EXECSTACK="opt/${MY_PN}/lib/${MY_PN}"

src_install() {
	local d=${GAMES_PREFIX_OPT}/${MY_PN}

	insinto "${d}"
	doins -r * || die

	games_make_wrapper ${MY_PN} "${d}"/${MY_PN}
	newicon icons/128x128.png ${MY_PN}.png
	make_desktop_entry ${MY_PN} "And Yet It Moves" ${MY_PN}

	pushd "${D}${d}" >/dev/null
	chmod a+rx ${MY_PN} lib/${MY_PN} || die
	popd > /dev/null

	prepgamesdirs
}
