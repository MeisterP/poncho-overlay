# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_BUILD_TYPE="Release"

inherit cmake

DESCRIPTION="Compiler lowering PyTorch, JAX, Flax, and Keras models to portable GGML execution"
HOMEPAGE="https://github.com/monatis/ggmlc"

SRC_URI="https://github.com/monatis/ggmlc/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	local mycmakeargs=(
		# optimizes the vendored ggml for the build host; host-specific binary
		-DGGML_NATIVE=ON

		# Laya is the example we ship; skip the rest
		-DGGMLC_BUILD_EXAMPLES=ON
		-DGGMLC_BUILD_EXAMPLE_LAYA=ON
		-DGGMLC_BUILD_EXAMPLE_TAB_COMPLETION=OFF
		-DGGMLC_BUILD_EXAMPLE_TIMESFM=OFF
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/runtime/ggmlc-run
	dobin "${BUILD_DIR}"/runtime/ggmlc-bench
	dolib.so "${BUILD_DIR}"/runtime/libggmlc_runtime_shared.so

	dobin "${BUILD_DIR}"/examples/laya/laya
}
