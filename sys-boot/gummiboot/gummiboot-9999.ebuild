# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Simple UEFI Boot Manager"
HOMEPAGE="http://freedesktop.org/wiki/Software/gummiboot"
EGIT_REPO_URI="git://anongit.freedesktop.org/gummiboot"
inherit toolchain-funcs autotools git-2

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-boot/gnu-efi-3.0s"

DEPEND=">=sys-boot/gnu-efi-3.0s"

pkg_setup(){
	local iarch
	case $ARCH in
		ia64)  iarch=ia64 ;;
		x86)   iarch=ia32 ;;
		amd64) iarch=x86_64 ;;
		*)     die "unknown architecture: $ARCH" ;;
	esac
}

src_prepare(){
	eautoreconf
}

pkg_postinst(){
	einfo	"To use ${PN}, excute"
	einfo 	"gummiboot --path \"path to ESP(Efi system partition)\" install "
}
