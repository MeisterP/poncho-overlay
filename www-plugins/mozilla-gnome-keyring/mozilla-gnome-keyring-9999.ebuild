# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib mozextension git-2

DESCRIPTION="A Firefox and Thunderbird extension that enables Gnome Keyring integration"
HOMEPAGE="http://github.com/infinity0/mozilla-gnome-keyring"
EGIT_REPO_URI="git://github.com/infinity0/mozilla-gnome-keyring.git"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="+firefox thunderbird"

DEPEND="gnome-base/gnome-keyring
	firefox? ( www-client/firefox[-minimal] )
	thunderbird? ( mail-client/thunderbird[-minimal] )"
RDEPEND="${DEPEND}"

use firefox && moz_pkg_enable="firefox"
use thunderbird && moz_pkg_enable="${moz_pkg_enable} thunderbird"

src_unpack() {
	git-2_src_unpack

	for moz_pkg in ${moz_pkg_enable}; do
		einfo "Unpacking ${moz_pkg} extension"
		cp -r "${S}" "${WORKDIR}/${P}-${moz_pkg}" || die
	done
}

src_compile() {
	for moz_pkg in ${moz_pkg_enable}; do
		einfo "Compiling ${moz_pkg} extension"
		cd "${WORKDIR}/${P}-${moz_pkg}" || die

		MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${moz_pkg}"

		#pkg-config file for Firefox/Thunderbird is missing, so we are forced to use hardcodes
		XUL_CFLAGS="-I${MOZILLA_FIVE_HOME/$(get_libdir)/include} -I/usr/include/nspr"
		XPCOM_ABI_FLAGS="-Wl,-rpath=${MOZILLA_FIVE_HOME}"
		XUL_LDFLAGS="-L${MOZILLA_FIVE_HOME} -L${MOZILLA_FIVE_HOME}/sdk/lib \
			-lxpcomglue_s -lxul -lxpcom -lmozalloc -lmozsqlite3 -lplds4 -lplc4 \
			-lnspr4 -lpthread -ldl"

		[[ "${moz_pkg}" == "thunderbird" ]] && XUL_LDFLAGS="${XUL_LDFLAGS} -lldap60 -lprldap60"

		emake \
			XUL_CFLAGS="${XUL_CFLAGS}" \
			XUL_LDFLAGS="${XUL_LDFLAGS}" \
			XPCOM_ABI_FLAGS="${XPCOM_ABI_FLAGS}"
	done
}

src_install() {
	for moz_pkg in ${moz_pkg_enable}; do
		einfo "Installing ${moz_pkg} extension"
		MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${moz_pkg}"
		xpi_install "${WORKDIR}/${P}-${moz_pkg}/xpi"
	done

	dodoc "${S}/README"
}
