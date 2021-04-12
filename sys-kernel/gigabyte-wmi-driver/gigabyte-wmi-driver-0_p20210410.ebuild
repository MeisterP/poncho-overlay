# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-mod

MY_COMMIT="21310d9959ca8c30b4e6187277031b2f89ac493c"

DESCRIPTION="Linux Driver for WMI on Gigabyte Mainboards"
HOMEPAGE="https://github.com/t-8ch/linux-gigabyte-wmi-driver"
SRC_URI="https://github.com/t-8ch/linux-gigabyte-wmi-driver/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/linux-gigabyte-wmi-driver-${MY_COMMIT}

BUILD_TARGETS="modules"
MODULE_NAMES="gigabyte-wmi(misc:${S}:${S})"
MODULESD_GIGABYTE_WMI_ENABLED="yes"
MODULESD_GIGABYTE_WMI_DOCS="${S}/README.md"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KDIR=${KV_DIR}"
}
