# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="EFI-Shell - provides native UDK implemenations of a UEFI Shell 2.0"
HOMEPAGE="https://github.com/tianocore/tianocore.github.io/wiki/EDK-II"
SRC_URI="https://github.com/tianocore/edk2/releases/download/edk2-stable201911/ShellBinPkg.zip -> ${P}.zip"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="app-arch/unzip"
DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto "/usr/share/${PN}"
	newins UefiShell/X64/Shell.efi shellx64.efi
	dodoc UefiShell/UefiShell.inf
}

S="${WORKDIR}/ShellBinPkg"

pkg_postinst() {
	elog "To support your motherboards \"Launch EFI Shell from filesystem device\""
	elog "funcitonality, copie /usr/share/${PN}/shellx64.efi to "
	elog "<EFI_SYSTEM_PARTITION>/shellx64.efi"
}
