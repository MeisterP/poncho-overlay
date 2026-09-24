# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ROCM_VERSION="7.2"
CMAKE_BUILD_TYPE="Release"

inherit cmake cuda rocm linux-info toolchain-funcs

MY_PN="${PN/-cpp/.cpp}"
MY_PV="master-900-c92d73c"
GGML_COMMIT="4bf5f6000653b7881d00963cd6ddb665ccd62a8d"

WEBUI_COMMIT="c4bce3d6b3f236614cca21014f076083b7270ba8"
# git clone https://github.com/leejet/sdcpp-webui
# git -C sdcpp-webui checkout ${WEBUI_COMMIT}
# cd sdcpp-webui
# npm install
# npm run build
# npm run build:header
# tar czf /var/cache/distfiles/${P}-webui.tar.gz dist

DESCRIPTION="Diffusion model(SD,Flux,Wan,Qwen Image,Z-Image,...) inference in pure C/C++"
HOMEPAGE="https://github.com/leejet/stable-diffusion.cpp"

SRC_URI="https://github.com/leejet/stable-diffusion.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://github.com/leejet/ggml/archive/${GGML_COMMIT}.tar.gz -> ${P}-GGML.tar.gz
	webui? (
		${P}-webui.tar.gz
	)
"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="blis cuda flexiblas openblas opencl +openmp rocm vulkan webm webp webui"

# ggml/CMakeLists.txt
CPU_FLAGS_X86=( sse4_2 avx avx_vnni avx2 bmi2 avx512f avx512vbmi avx512_vnni avx512_bf16 fma3 f16c amx_tile amx_int8 amx_bf16)
IUSE+=" ${CPU_FLAGS_X86[@]/#/cpu_flags_x86_}"

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
		-DCMAKE_CUDA_ARCHITECTURES="120" # my gpu only
		-DGGML_CUDA_FA_QUANTS=all
		-DGGML_CUDA_NCCL=OFF

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
		local -x CUDAHOSTCXX="$(cuda_gccdir)"
		# tries to recreate dev symlinks
		cuda_add_sandbox
		addpredict "/dev/char/"
	fi

	if use rocm; then
		export HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -p)"
		mycmakeargs+=(
			-DSD_HIPBLAS=ON
			-DGPU_TARGETS=$(get_amdgpu_flags)
		)
	fi

	cmake_src_configure
}
