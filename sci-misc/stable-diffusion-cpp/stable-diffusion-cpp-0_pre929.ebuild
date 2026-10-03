# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION="7.2"
CMAKE_BUILD_TYPE="Release"

inherit cmake cuda rocm linux-info toolchain-funcs

MY_PN="${PN/-cpp/.cpp}"
MY_PV="master-929-3f8527a"
GGML_COMMIT="89c4413f5da6fb20cc796f16033d37f129be81fd"

WEBUI_COMMIT="dd74a8e808aaa8b26124217424b23058935184de"
# git clone https://github.com/leejet/sdcpp-webui
# cd sdcpp-webui
# git checkout ${WEBUI_COMMIT}
# npm install
# npm run build
# npm run build:header
# tar czf /var/cache/distfiles/stable-diffusion-cpp-${WEBUI_COMMIT}-webui.tar.gz dist

DESCRIPTION="Diffusion model(SD,Flux,Wan,Qwen Image,Z-Image,...) inference in pure C/C++"
HOMEPAGE="https://github.com/leejet/stable-diffusion.cpp"

SRC_URI="https://github.com/leejet/stable-diffusion.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/leejet/ggml/archive/${GGML_COMMIT}.tar.gz -> ${PN}-${GGML_COMMIT}-GGML.tar.gz
	webui? (
		${PN}-${WEBUI_COMMIT}-webui.tar.gz
	)
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# GGML CPU flags
X86_CPU_FLAGS=(
	amx_bf16
	amx_int8
	amx_tile
	avx
	avx2
	avx512_bf16
	avx512_vnni
	avx512f
	avx512vbmi
	avx_vnni
	bmi2
	f16c
	fma3
	sse4_2
)
CPU_FLAGS=( "${X86_CPU_FLAGS[@]/#/cpu_flags_x86_}" )
GGML_IUSE="${CPU_FLAGS[*]} blis cuda flexiblas openblas opencl +openmp rocm vulkan"
unset X86_CPU_FLAGS CPU_FLAGS

IUSE="${GGML_IUSE} webm webp webui"
unset GGML_IUSE
REQUIRED_USE="
	?? (
		openblas
		blis
		flexiblas
	)
	rocm? ( ${ROCM_REQUIRED_USE} )
	webm? (
		webp
	)
"

COMMON_DEPEND="
	openblas? ( sci-libs/openblas:= )
	openmp? ( llvm-runtimes/openmp:= )
	blis? ( sci-libs/blis:= )
	flexiblas? ( sci-libs/flexiblas:= )
	rocm? (
		>=dev-util/hip-${ROCM_VERSION}:=
		>=sci-libs/hipBLAS-${ROCM_VERSION}:=
	)
	cuda? ( dev-util/nvidia-cuda-toolkit:= )
	webp? ( media-libs/libwebp )
	webm? ( media-libs/libwebm )
"
DEPEND="${COMMON_DEPEND}
	opencl? ( dev-util/opencl-headers )
	vulkan? (
		dev-util/spirv-headers
		dev-util/vulkan-headers
	)
"
RDEPEND="${COMMON_DEPEND}
	opencl? ( dev-libs/opencl-icd-loader )
	vulkan? ( media-libs/vulkan-loader )
"
BDEPEND="vulkan? ( media-libs/shaderc )"

PATCHES=( ${FILESDIR}/prefer-prebuilt-frontend.patch )

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	if use rocm; then
		linux-info_pkg_setup
		if linux-info_get_any_version && linux_config_exists; then
			if ! linux_chkconfig_present HSA_AMD_SVM; then
				ewarn "To use ROCm/HIP, you need to have HSA_AMD_SVM option enabled in your kernel."
			fi
		fi
	fi

	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	use cuda && cuda_src_prepare
	cmake_src_prepare

	rm -r ${S}/ggml || die
	mv ${WORKDIR}/ggml-${GGML_COMMIT} ${S}/ggml || die

	if use webui; then
		mv ${WORKDIR}/dist ${S}/examples/server/frontend/ || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DSD_BUILD_EXAMPLES=ON
		-DSD_WEBP=$(usex webp)
		-DSD_USE_SYSTEM_WEBP=$(usex webp)
		-DSD_WEBM=$(usex webm)
		-DSD_USE_SYSTEM_WEBM=$(usex webm)

		# GGML features controls
		-DSD_CUDA=$(usex cuda)
		-DSD_VULKAN=$(usex vulkan)
		-DSD_OPENCL=$(usex opencl)
		-DSD_RPC=ON

		-DSD_BUILD_SHARED_LIBS=OFF
		-DSD_SERVER_BUILD_FRONTEND=$(usex webui ON OFF)

		# avoid clashing with sci-ml/ggml
		-DCMAKE_INSTALL_INCLUDEDIR="include/${MY_PN}"
		-DCMAKE_INSTALL_LIBDIR="$(get_libdir)/${MY_PN}"
		-DCMAKE_INSTALL_RPATH="\$ORIGIN/../$(get_libdir)/${MY_PN};\$ORIGIN"
	)

	# GGML backends
	mycmakeargs+=(
		-DGGML_NATIVE=OFF	# don't set march
		-DGGML_CCACHE=OFF
		-DGGML_LTO="$(tc-is-lto)"

		# CPU Flags
		-DGGML_SSE42=$(usex cpu_flags_x86_sse4_2)
		-DGGML_AVX=$(usex cpu_flags_x86_avx)
		-DGGML_AVX_VNNI=$(usex cpu_flags_x86_avx_vnni)
		-DGGML_AVX2=$(usex cpu_flags_x86_avx2)
		-DGGML_BMI2=$(usex cpu_flags_x86_bmi2)
		-DGGML_AVX512=$(usex cpu_flags_x86_avx512f)
		-DGGML_AVX512_VBMI=$(usex cpu_flags_x86_avx512vbmi)
		-DGGML_AVX512_VNNI=$(usex cpu_flags_x86_avx512_vnni)
		-DGGML_AVX512_BF16=$(usex cpu_flags_x86_avx512_bf16)
		-DGGML_FMA=$(usex cpu_flags_x86_fma3)
		-DGGML_F16C=$(usex cpu_flags_x86_f16c)
		-DGGML_AMX_TILE=$(usex cpu_flags_x86_amx_tile)
		-DGGML_AMX_INT8=$(usex cpu_flags_x86_amx_int8)
		-DGGML_AMX_BF16=$(usex cpu_flags_x86_amx_bf16)

		-DGGML_OPENMP=$(usex openmp)
	)

	if use openblas ; then
		mycmakeargs+=(
			-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS
		)
	fi

	if use blis ; then
		mycmakeargs+=(
			-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=FLAME
		)
	fi

	if use flexiblas; then
		mycmakeargs+=(
			-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=FlexiBLAS
		)
	fi

	if use cuda; then
		cuda_add_sandbox -w
		addpredict "/dev/char/"
		cuda_sanitize
		mycmakeargs+=(
			-DCMAKE_CUDA_FLAGS="${NVCCFLAGS}"
			-DCMAKE_CUDA_ARCHITECTURES="120" # my gpu only
			-DGGML_CUDA_FA_QUANTS=all
			-DGGML_CUDA_NCCL=OFF
		)
	fi

	if use rocm; then
		rocm_use_hipcc
		mycmakeargs+=(
			-DSD_HIPBLAS=ON
			-DGPU_TARGETS=$(get_amdgpu_flags)
		)
	fi

	cmake_src_configure
}
