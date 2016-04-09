# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="EFI-Shell - provides native UDK implemenations of a UEFI Shell 2.0"
HOMEPAGE="http://www.tianocore.org/"
SRC_URI="https://github.com/tianocore/udk/releases/download/UDK${PV}/UDK${PV}.MyWorkSpace.zip
	-> ${P}.zip"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/MyWorkSpace"

src_install() {
	insinto "/usr/share/${PN}"
	newins ShellBinPkg/UefiShell/X64/Shell.efi shellx64.efi

	dodoc ShellBinPkg/ReadMe.txt
}

pkg_postinst() {
	elog "To support your motherboards \"Launch EFI Shell from filesystem device\""
	elog "funcitonality, copie /usr/share/${PN}/shellx64.efi to "
	elog "<EFI_SYSTEM_PARTITION>/shellx64.efi"
}
