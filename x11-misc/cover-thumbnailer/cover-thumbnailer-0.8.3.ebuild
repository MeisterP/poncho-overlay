# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python{2_5,2_6,2_7} )
inherit python-single-r1 versionator

DESCRIPTION="Display covers on folders in nautilus"
HOMEPAGE="http://projects.flogisoft.com/cover-thumbnailer/"

CPV=$(get_version_component_range '1-2')
SRC_URI="http://launchpad.net/${PN}/v${CPV}/v${PV}/+download/${PN}_${PV}_src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"
LANGS="ar ca cs da de el en_GB es fr gl he hr hu it ja ko ms nl oc pl pt pt_BR
ro ru sk sv tr uk zh_CN zh_TW"

for X in ${LANGS} ; do
	IUSE+=" linguas_${X}"
done

DEPEND="sys-devel/gettext
	>=gnome-base/nautilus-3.0"

RDEPEND="${DEPEND}
	dev-python/imaging[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]"

S="${S%-${PV}}_${PV}_src"

src_install() {
	python_newscript ${PN}.py ${PN}
	python_newscript ${PN}-gui.py ${PN}-gui

	insinto /usr/share/${PN}
	doins share/*

	insinto /usr/share/applications
	doins freedesktop/cover-thumbnailer-gui.desktop

	insinto /usr/share/thumbnailers
	doins freedesktop/cover.thumbnailer

	doman man/*
	dodoc README

	if use nls; then
		cd locale/
		for n in *.po; do
			n=${n/.po}
			if use linguas_${n}; then
				msgfmt -o ${n}.mo ${n}.po \
					|| die "Compilation of locale ${n} failed."
				insinto /usr/share/locale/${n}/LC_MESSAGES
				newins ${n}.mo ${PN}.mo \
					|| die "Installation of locale ${n} failed."
			fi
		done
	fi
}

pkg_postinst() {
	if ! has_version ${CATEGORY}/${PN}; then
		einfo "It is necessary to relog in your session for"
		einfo "cover-thumbnailer to start working."
	fi
}
