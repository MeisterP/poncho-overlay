# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/nxclient/nxclient-3.4.0.7-r1.ebuild,v 1.1 2010/12/22 09:47:27 voyageur Exp $

EAPI=2
inherit eutils versionator

MAJOR_PV="$(get_version_component_range 1-3)"
FULL_PV="${MAJOR_PV}-$(get_version_component_range 4)"
DESCRIPTION="New NX client interface"
HOMEPAGE="http://www.nomachine.com/"
SRC_URI="amd64? ( http://64.34.161.181/download/4.0/Linux/nxplayer-${FULL_PV}.x86_64.tar.gz )
	x86? ( http://64.34.161.181/download/4.0/Linux/nxplayer-${FULL_PV}.i686.tar.gz )"
LICENSE="nomachine"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

DEPEND=""
RDEPEND="x11-libs/libXft
	x11-libs/libX11
	x11-libs/libXdmcp
	x11-libs/libXau"

S=${WORKDIR}/NX/etc/NX/packages/player/

src_install()
{
	local NXROOT=/opt/NX

#	dodir /etc/NX/localhost
#	echo 'PlayerRoot = "'"${NXROOT}"'"' > ${D}/etc/NX/localhost/player.cfg

	dodir /opt
	tar xozf nxclient.tar.gz -C "${D}"/opt
	tar xozf nxplayer.tar.gz -C "${D}"/opt

	make_wrapper nxplayer ./nxplayer ${NXROOT}/bin ${NXROOT}/lib || die
	# Add icons/desktop entries (missing in the tarball)
	cd "${D}"/${NXROOT}/share/icons
	for size in *; do
		dodir /usr/share/icons/hicolor/${size}/apps
		for icon in desktop icon; do
			dosym /usr/NX/share/icons/${size}/nxplayer-${icon}.png \
				/usr/share/icons/hicolor/${size}/apps
			done
		done
	make_desktop_entry "nxplayer" "NX Player" nxplayer-icon
}
