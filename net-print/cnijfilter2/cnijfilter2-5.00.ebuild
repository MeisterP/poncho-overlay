# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Canon InkJet Printer Driver for Linux (Pixus/Pixma-Series)"
HOMEPAGE="http://www.canon-europe.com/Support/"
SRC_URI="http://gdlp01.c-wss.com/gds/3/0100006263/01/${PN}-source-${PV}-1.tar.gz"

LICENSE="GPL-2 cnijfilter"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND="dev-libs/libxml2
	net-print/cups"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-source-${PV}-1"

src_prepare () {
	for i in cmdtocanonij2 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg
	do
		pushd $i
		eautoreconf
		popd
	done
}

src_configure () {
	pushd cmdtocanonij2
	econf --prefix=/usr \
		--datadir=/usr/share \
		LDFLAGS="-L../../com/libs_bin64"
	popd

	pushd cnijbe2
	econf --prefix=/usr \
		--enable-progpath=/usr/bin
	popd

	pushd lgmon3
	econf --prefix=/usr \
		--enable-libpath=/usr/lib/bjlib2 \
		--enable-progpath=/usr/bin \
		--datadir=/usr/share \
		LDFLAGS="-L../../com/libs_bin64"
	popd

	pushd rastertocanonij
	econf --prefix=/usr \
		--enable-progpath=/usr/bin
	popd

	pushd tocanonij
	econf --prefix=/usr
	popd

	pushd tocnpwg
	econf --prefix=/usr
	popd
}

src_compile () {
	for i in cmdtocanonij2 cnijbe2 lgmon3 rastertocanonij tocanonij tocnpwg
	do
		pushd $i
		emake
		popd
	done
}

src_install () {
	pushd cmdtocanonij2
	exeinto /usr/libexec/cups/filter
	doexe filter/cmdtocanonij2
	emake DESTDIR="${D}" install
	popd

	pushd cnijbe2
	exeinto /usr/libexec/cups/backend
	doexe src/cnijbe2
	emake DESTDIR="${D}" install
	popd

	pushd lgmon3
	emake DESTDIR="${D}" install
	popd

	pushd rastertocanonij
	exeinto /usr/libexec/cups/filter
	doexe src/rastertocanonij
	emake DESTDIR="${D}" install
	popd

	pushd tocanonij
	emake DESTDIR="${D}" install
	popd

	pushd tocnpwg
	emake DESTDIR="${D}" install
	popd

	# all files in /usr/libexec/cups
	rm -rf "${D}"/usr/lib{,64} || die

	insinto /usr/share/cups/model
	doins ppd/*.ppd

	insinto /usr/lib64/bjlib2
	doins com/ini/cnnet.ini

	dolib com/libs_bin64/libcnbpcnclapicom2.so.5.0.0
	dosym libcnbpcnclapicom2.so.5.0.0 /usr/lib64/libcnbpcnclapicom2.so
	dolib com/libs_bin64/libcnnet2.so.1.2.3
	dosym libcnnet2.so.1.2.3 /usr/lib64/libcnnet2.so

	dodoc lproptions/lproptions*EN.txt
}
