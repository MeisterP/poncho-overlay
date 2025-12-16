# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

MY_COMMIT="60d9def80d65e7e34a73e6f32d8677ad5bfa58a9"

DESCRIPTION="IT8705F/IT871xF/IT872xF hardware monitoring driver"
HOMEPAGE="https://github.com/frankcrawford/it87"

SRC_URI="https://github.com/frankcrawford/it87/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/it87-${MY_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

DOCS=(
	"${S}/README"
	"${S}/ISSUES"
)

pkg_setup() {
	linux-mod-r1_pkg_setup

	# Using a CONFIG_CHECK wasn't quite right because we package a depmod.d file
	#  to override the in-tree module, so we don't want to warn the user if they
	#  have a supported config.
	if linux_config_exists && linux_chkconfig_builtin SENSORS_IT87
	then
		ewarn "You will not be able to load this module because the in-tree version is builtin"
		ewarn "(CONFIG_SENSORS_IT87=y in your kernel config)! Please recompile your kernel"
		ewarn "with CONFIG_SENSORS_IT87=m or =n to use this module."
	fi
}

src_compile() {
	local modlist=( it87=hwmon:"${S}":"${S}":all )
	local modargs=( TARGET="${KV_FULL}" )

	linux-mod-r1_src_compile
}

src_install() {
	linux-mod-r1_src_install

	mkdir -p "${ED}/lib/depmod.d" || die
	echo "override ${PN} ${KV_FULL} hwmon" > "${ED}/lib/depmod.d/${PN}.conf" || die
}
