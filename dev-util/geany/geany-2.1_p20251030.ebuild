# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic optfeature strip-linguas xdg

LANGS="ar ast be bg ca cs de el en_GB es et eu fa fi fr gl he hi hu id it ja kk ko ku lb lt ltg mn nl nn pl pt pt_BR ro ru si sk sl sr sv ta tr uk vi zh_CN ZH_TW"
NOSHORTLANGS="en_GB zh_CN zh_TW"

MY_COMMIT="426e427030fe0118648efbec5e76b2b1ddca9e5c"

DESCRIPTION="GTK+ based fast and lightweight IDE"
HOMEPAGE="https://www.geany.org"

SRC_URI="https://github.com/geany/geany/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/geany-${MY_COMMIT}"

LICENSE="GPL-2+ HPND LGPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+vte wayland X"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.24:3[wayland?,X?]
	!x11-themes/geany-themes
	vte? ( x11-libs/vte:2.91 )
"
DEPEND="
	${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
"

pkg_setup() {
	strip-linguas ${LANGS}
}

src_prepare() {
	xdg_environment_reset #588570
	default

	# Syntax highlighting for Portage
	sed -i -e "s:*.sh;:*.sh;*.ebuild;*.eclass;:" \
		data/filetype_extensions.conf || die

	eautoreconf
}

src_configure() {
	use X || append-cflags -DGENTOO_GTK_HIDE_X11
	use wayland || append-flags -DGENTOO_GTK_HIDE_WAYLAND

	local myeconfargs=(
		--disable-html-docs
		--disable-pdf-docs
		--disable-static
		$(use_enable vte)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_preinst() {
	xdg_pkg_preinst
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "editing files outside the local filesystem" gnome-base/gvfs
	optfeature "opening files from the file browser tab" x11-misc/xdg-utils
}

pkg_postrm() {
	xdg_pkg_postrm
}
