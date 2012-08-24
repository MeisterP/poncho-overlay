# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib mozextension git-2

MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"

DESCRIPTION="A firefox extension that enables Gnome Keyring integration"
HOMEPAGE="https://github.com/infinity0/mozilla-gnome-keyring"
EGIT_REPO_URI="git://github.com/infinity0/mozilla-gnome-keyring.git"

if [[ ${PV} != "9999" ]] ; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="~x86 ~amd64"
fi

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
IUSE=""
RESTRICT="mirror"

DEPEND="www-client/firefox[-minimal]
gnome-base/gnome-keyring"
RDEPEND="${DEPEND}"

src_compile() {
	#pkg-config file for Firefox is missing, so we are forced to use hardcodes
	emake XUL_CFLAGS="-I/usr/include/firefox -I/usr/include/nspr" XUL_LDFLAGS="-L${MOZILLA_FIVE_HOME} -L${MOZILLA_FIVE_HOME}/sdk/lib -lxpcomglue_s -lxul -lxpcom -lmozalloc -lmozsqlite3 -lplds4 -lplc4 -lnspr4 -lpthread -ldl" XPCOM_ABI_FLAGS="-Wl,-rpath=${MOZILLA_FIVE_HOME}"
}

src_install() {
	xpi_install "${S}/xpi"
}
