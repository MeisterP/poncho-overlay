# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib mozextension

DESCRIPTION="A Firefox and Thunderbird extension that enables Gnome Keyring integration"
HOMEPAGE="http://github.com/infinity0/mozilla-gnome-keyring"
SRC_URI="http://github.com/infinity0/mozilla-gnome-keyring/tarball/${PV} \
				-> ${P}.tar.gz"

LICENSE="MPL-1.1 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+firefox thunderbird"

DEPEND="gnome-base/gnome-keyring
	firefox? ( www-client/firefox[-minimal] )
	thunderbird? ( mail-client/thunderbird[-minimal] )"
RDEPEND="${DEPEND}"

use firefox && moz_pkg_enable="firefox"
use thunderbird && moz_pkg_enable+=" thunderbird"

src_unpack() {
	default
	mv infinity0-${PN}-[0-9a-f]*[0-9a-f]/ "${S}" || die
}

src_prepare() {
	for moz_pkg in ${moz_pkg_enable}; do
		einfo "Copying source to ${P}-${moz_pkg}"
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
		XUL_LDFLAGS="-L${MOZILLA_FIVE_HOME} -L${MOZILLA_FIVE_HOME}/sdk/lib \
			-lxpcomglue_s -lxul -lxpcom -lmozalloc -lmozsqlite3 -lplds4 -lplc4 \
			-lnspr4 -lpthread -ldl"
		XPCOM_ABI_FLAGS="-Wl,-rpath=${MOZILLA_FIVE_HOME}"

		if [[ "${moz_pkg}" == "thunderbird" ]]; then
			has_version mail-client/thunderbird[ldap] && XUL_LDFLAGS+=" -lldap60 -lprldap60"
		fi

		emake VERSION="${PV}" \
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
