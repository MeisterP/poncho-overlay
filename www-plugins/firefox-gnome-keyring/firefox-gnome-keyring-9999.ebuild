# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib mozextension git-2

DESCRIPTION="A Firefox extension that enables Gnome Keyring integration"
HOMEPAGE="http://github.com/infinity0/mozilla-gnome-keyring"
EGIT_REPO_URI="git://github.com/infinity0/mozilla-gnome-keyring.git"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="gnome-base/gnome-keyring
	>=www-client/firefox-22.0[-minimal]
	!www-plugins/mozilla-gnome-keyring"
RDEPEND="${DEPEND}"

src_compile() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"

	#pkg-config file for Firefox/Thunderbird is missing, so we are forced to use hardcodes
	XUL_CFLAGS="-I${MOZILLA_FIVE_HOME/$(get_libdir)/include} -I/usr/include/nspr"
	XUL_LDFLAGS="-L${MOZILLA_FIVE_HOME} -L${MOZILLA_FIVE_HOME}/sdk/lib \
		-lxpcomglue_s -lxul -lmozalloc -lmozsqlite3 -lplds4 -lplc4 \
		-lnspr4 -lpthread -ldl"
	XPCOM_ABI_FLAGS="-Wl,-rpath=${MOZILLA_FIVE_HOME}"

	emake VERSION="${PV}" \
		XUL_CFLAGS="${XUL_CFLAGS}" \
		XUL_LDFLAGS="${XUL_LDFLAGS}" \
		XPCOM_ABI_FLAGS="${XPCOM_ABI_FLAGS}"
}

src_install() {
	mozversion_extension_location() {
		if has_version >=www-client/firefox-21.0; then
			return 1
		else
			return 0
		fi
	}

	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/firefox"
	xpi_install "${WORKDIR}/${P}/xpi"

	dodoc "${S}/README"
}
