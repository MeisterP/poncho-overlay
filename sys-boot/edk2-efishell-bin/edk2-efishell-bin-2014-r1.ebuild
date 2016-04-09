# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="EFI-Shell - provides native UDK implemenations of a UEFI Shell 2.0"
HOMEPAGE="http://www.tianocore.org/edk2/"
SRC_URI="https://raw.githubusercontent.com/tianocore/edk2/UDK2014.SP1/EdkShellBinPkg/FullShell/X64/Shell_Full.efi
	-> ${P}.efi"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/${P}.efi "${WORKDIR}"/shellx64.efi || die
}

src_install() {
	insinto "/usr/share/${PN}"
	doins shellx64.efi
}

pkg_postinst() {
	elog "To support your motherboards \"Launch EFI Shell from filesystem device\""
	elog "funcitonality, copie /usr/share/${PN}/shellx64.efi to "
	elog "<EFI_SYSTEM_PARTITION>/shellx64.efi"
}
