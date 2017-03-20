# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PLOCALES="ca cs de el es fr it ja pt_BR ru sr sr@latin tr"

inherit eutils cmake-utils flag-o-matic l10n

SLOT="2.6"

DESCRIPTION="Video editor designed for simple cutting, filtering and encoding tasks"
HOMEPAGE="http://fixounet.free.fr/avidemux"

# Multiple licenses because of all the bundled stuff.
LICENSE="GPL-1 GPL-2 MIT PSF-2 public-domain"
IUSE="debug opengl nls qt5 sdl vaapi vdpau video_cards_fglrx xv"
KEYWORDS="~amd64 ~x86"

MY_P="${PN}_${PV}"

SRC_URI="mirror://sourceforge/${PN}/${PN}/${PV}/${MY_P}.tar.gz"

DEPEND="
	~media-libs/avidemux-core-${PV}:${SLOT}[nls?,sdl?,vaapi?,vdpau?,video_cards_fglrx?,xv?]
	opengl? ( virtual/opengl:0 )
	qt5? ( dev-qt/qtgui:5
		dev-qt/qtscript:5 )
	vaapi? ( x11-libs/libva:0 )
	video_cards_fglrx? ( x11-drivers/xf86-video-amdgpu )
"
RDEPEND="$DEPEND"
PDEPEND="~media-libs/avidemux-plugins-${PV}:${SLOT}[opengl?,qt5?]"

DOCS=( AUTHORS README )
PATCHES=( ${FILESDIR}/2.6.12-fix-desktop-file.patch )

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	processes="buildCli:avidemux/cli"
	use qt5 && processes+=" buildQt5:avidemux/qt4"

	# Remove "Build Option" dialog because it doesn't reflect what the GUI can or has been built with. (Bug #463628)
	sed -i -e '/Build Option/d' avidemux/common/ADM_commonUI/myOwnMenu.h || die "Couldn't remove \"Build Option\" dialog."
}

src_configure() {
	local mycmakeargs=(
		-DAVIDEMUX_SOURCE_DIR='${S}'
		-DENABLE_QT5="$(usex qt5)"
		-DOPENGL=OFF
		-DGETTEXT="$(usex nls)"
		-DSDL="$(usex sdl)"
		-DLIBVA="$(usex vaapi)"
		-DVDPAU="$(usex vdpau)"
		-DXVBA="$(usex video_cards_fglrx)"
		-DXVIDEO="$(usex xv)"
	)

	if use debug ; then
		mycmakeargs+=( -DVERBOSE=1 -DCMAKE_BUILD_TYPE=Debug -DADM_DEBUG=1 )
	fi

	# Needed for gcc-6
	append-cxxflags $(test-flags-CXX -std=gnu++98)

	# Add lax vector typing for PowerPC.
	if use ppc || use ppc64 ; then
		append-cflags -flax-vector-conversions
	fi

	# See bug 432322.
	use x86 && replace-flags -O0 -O1

	for process in ${processes} ; do
		local build="${process%%:*}"

		mkdir "${S}"/${build} || die "Can't create build folder."
		cd "${S}"/${build} || die "Can't enter build folder."
		CMAKE_USE_DIR="${S}"/${process#*:} BUILD_DIR="${S}"/${build} cmake-utils_src_configure
	done
}

src_compile() {
	for process in ${processes} ; do
		QT_SELECT=5 BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_compile
	done
}

src_install() {
	for process in ${processes} ; do
		BUILD_DIR="${S}/${process%%:*}" cmake-utils_src_install
	done

	if [[ -f "${ED}"/usr/bin/avidemux3_cli ]] ; then
		fperms +x /usr/bin/avidemux3_cli
	fi

	if [[ -f "${ED}"/usr/bin/avidemux3_jobs ]] ; then
		fperms +x /usr/bin/avidemux3_jobs
	fi

	cd "${S}" || die "Can't enter source folder."
	newicon ${PN}_icon.png ${PN}-2.6.png

	if use qt5 ; then
		fperms +x /usr/bin/avidemux3_qt5
		domenu ${PN}2-6.desktop
	fi
}
