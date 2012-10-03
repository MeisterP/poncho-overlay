# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils gnome2-utils

DESCRIPTION="Utility for advanced configuration of Roccat devices"

HOMEPAGE="http://roccat.sourceforge.net/"
SRC_URI="mirror://sourceforge/roccat/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE_INPUT_DEVICES="
	input_devices_arvo
	input_devices_isku
	input_devices_kone
	input_devices_koneplus
	input_devices_kovaplus
	input_devices_pyra
	input_devices_savu
"
IUSE="${IUSE_INPUT_DEVICES}"

RDEPEND="
	x11-libs/gtk+:2
	x11-libs/libnotify
	media-libs/libcanberra
	virtual/libusb:1
	<dev-libs/libunique-3
	dev-libs/dbus-glib
	sys-fs/udev[gudev]
"

DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs=( -DDEVICES=${INPUT_DEVICES// /;} )
	cmake-utils_src_configure
}

pkg_postinst() {
	enewgroup roccat
	gnome2_icon_cache_update
	elog "To allow users to use all features add them to the 'roccat' group"
	udevadm control --reload-rules && udevadm trigger --subsystem-match=usb
}

pkg_postrm() {
	gnome2_icon_cache_update
}
