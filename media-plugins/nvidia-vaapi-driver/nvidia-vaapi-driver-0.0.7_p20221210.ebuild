# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_COMMIT="4029d456846f9e1e13763466c9d95824e29ceefe"

DESCRIPTION="A VA-API implemention using NVIDIA's NVDEC"
HOMEPAGE="https://github.com/elFarto/nvidia-vaapi-driver"
#SRC_URI="https://github.com/elFarto/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/elFarto/${PN}/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="av1"

BDEPEND=">=media-libs/nv-codec-headers-11.1.5.1"
DEPEND="media-libs/gst-plugins-bad
	media-libs/libglvnd"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-01-install-path.patch" )

S="${WORKDIR}/${PN}-${MY_COMMIT}"
