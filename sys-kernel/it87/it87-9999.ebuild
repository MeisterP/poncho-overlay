# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Source: Written from scratch for sunset-repo overlay

EAPI=8

inherit git-r3 linux-mod-r1

DESCRIPTION="IT8705F/IT871xF/IT872xF hardware monitoring driver"
HOMEPAGE="https://github.com/frankcrawford/it87"
EGIT_REPO_URI="${HOMEPAGE}.git"

LICENSE="GPL-2+"
SLOT="0"
if [[ "${PV%9999}" == "${PV}" ]] ; then
	KEYWORDS="~amd64"
fi

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
