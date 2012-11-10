# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/shadowgrounds-survivor-bin/shadowgrounds-survivor-bin-0_beta11.ebuild,v 1.2 2011/04/21 08:50:11 vapier Exp $

inherit games eutils

DESCRIPTION="human survivors who battle against the ongoing alien onslaught"
HOMEPAGE="http://shadowgroundsgame.com/survivor/"
SRC_URI="survivorUpdate1.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=sys-libs/glibc-2.4
	>=sys-devel/gcc-4.3.0
	!amd64? (
		gnome-base/libglade
	)
	amd64? (
		app-emulation/emul-linux-x86-gtklibs
	)"

S=${WORKDIR}

d="${GAMES_PREFIX_OPT}/${PN}"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"
QA_TEXTRELS_amd64=${QA_TEXTRELS_x86}

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unzip -q "${DISTDIR}/${A}"
	rm lib*/lib{gcc_s,m,rt,selinux}.so.?
}

src_install() {
	local b bb

	doicon Survivor.xpm || die
	for b in bin launcher ; do
		bb="survivor-${b}"
		exeinto ${d}
		newexe ${bb} ${bb} || die
		games_make_wrapper ${bb} "./${bb}" "${d}" || die
		make_desktop_entry ${bb} "Shadowgrounds Survivor ${b}" "Survivor"
	done

	exeinto ${d}/lib32
	doexe lib32/* || die

	insinto ${d}
	doins -r Config data Profiles *.fbz *.glade *-logo.png || die

	prepgamesdirs
}
