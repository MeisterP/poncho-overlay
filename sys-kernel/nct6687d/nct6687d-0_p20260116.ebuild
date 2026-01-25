# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

MY_COMMIT="01351faf8baa05db57630bb0a7aa9fa30fd3023a"

DESCRIPTION="Kernel module for the Nuvoton NCT6687-R"
HOMEPAGE="https://github.com/Fred78290/nct6687d"

SRC_URI="https://github.com/Fred78290/nct6687d/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/nct6687d-${MY_COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/linux-sources"

src_compile() {
	local modlist=( nct6687=drivers/hwmon::${KV_FULL}:build )
	local modargs=( kver="${KV_FULL}" )
	linux-mod-r1_src_compile
}
