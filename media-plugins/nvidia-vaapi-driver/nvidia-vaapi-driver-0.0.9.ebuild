# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="A VA-API implemention using NVIDIA's NVDEC"
HOMEPAGE="https://github.com/elFarto/nvidia-vaapi-driver"
SRC_URI="https://github.com/elFarto/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="av1"

DEPEND="media-libs/gst-plugins-bad
	media-libs/libglvnd
	media-libs/libva
	>=media-libs/nv-codec-headers-11.1.5.1
	x11-libs/libdrm"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-01-install-path.patch" )

src_install() {
	meson_src_install

	newenvd - 99vaapi <<-EOF
		# Controls which backend this library uses. Either egl (default), or direct
		#NVD_BACKEND=direct

		# Controls the maximum concurrent instances of the driver will be allowed per-process
		#NVD_MAX_INSTANCES=
	EOF
}
