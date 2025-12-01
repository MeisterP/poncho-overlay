# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1 toolchain-funcs

DESCRIPTION="Python bindings generator for C/C++ libraries"
HOMEPAGE="https://github.com/Python-SIP/sip"
SRC_URI="https://www.riverbankcomputing.com/static/Downloads/${PN}/${PV}/${P}.tar.gz"

LICENSE="|| ( GPL-2 GPL-3 )"
# Sub-slot based on SIP_API_MAJOR_NR from siplib/sip.h
SLOT="0/12"
KEYWORDS="~amd64"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

# Fedora patches
# see https://src.fedoraproject.org/rpms/sip
PATCHES=(
	"${FILESDIR}"/${PN}-4.18-no_rpath.patch
	"${FILESDIR}"/${PN}-4.18-no_strip.patch
	"${FILESDIR}"/${PN}-4.19.18-no_hardcode_sip_so.patch
	"${FILESDIR}"/${P}-pyframe_getback.patch
	"${FILESDIR}"/${P}-py_ssize_t_clean.patch
	)

src_prepare() {
	# Sub-slot sanity check
	local sub_slot=${SLOT#*/}
	local sip_api_major_nr=$(sed -nre 's:^#define SIP_API_MAJOR_NR\s+([0-9]+):\1:p' siplib/sip.h || die)
	if [[ ${sub_slot} != ${sip_api_major_nr} ]]; then
		eerror
		eerror "Ebuild sub-slot (${sub_slot}) does not match SIP_API_MAJOR_NR (${sip_api_major_nr})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${sip_api_major_nr}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	default
}

src_configure() {
	configuration() {
		local incdir=$(python_get_includedir)
		local myconf=(
			"${EPYTHON}"
			"${S}"/configure.py
			--sysroot="${ESYSROOT}/usr"
			--bindir="${EPREFIX}/usr/bin"
			--destdir="$(python_get_sitedir)"
			--incdir="${incdir#${SYSROOT}}"
			--no-dist-info
			AR="$(tc-getAR) cqs"
			CC="$(tc-getCC)"
			CFLAGS="${CFLAGS}"
			CFLAGS_RELEASE=
			CXX="$(tc-getCXX)"
			CXXFLAGS="${CXXFLAGS}"
			CXXFLAGS_RELEASE=
			LINK="$(tc-getCXX)"
			LINK_SHLIB="$(tc-getCXX)"
			LFLAGS="${LDFLAGS}"
			LFLAGS_RELEASE=
			RANLIB=
			STRIP=
		)
		echo "${myconf[@]}"
		"${myconf[@]}" || die
	}
	python_foreach_impl run_in_build_dir configuration
}

src_compile() {
	python_foreach_impl run_in_build_dir default
}

src_install() {
	installation() {
		emake DESTDIR="${D}" install
		python_optimize
	}
	python_foreach_impl run_in_build_dir installation

	einstalldocs
	use doc && dodoc -r doc/html
}
