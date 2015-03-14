# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="EFI-Shell - provides native UDK implemenations of a UEFI Shell 2.0"
HOMEPAGE="https://tianocore.github.io/"
SRC_URI="https://svn.code.sf.net/p/edk2/code/branches/UDK${PV}.SP1/EdkShellBinPkg/FullShell/X64/Shell_Full.efi \
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
	insinto "/usr/share/${PN}/shell"
	doins shellx64.efi
}
