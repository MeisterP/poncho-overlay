# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop go-module xdg

EGO_SUM=(
	"github.com/fhs/gompd/v2 v2.2.1-0.20220620205817-bbf835995263"
	"github.com/fhs/gompd/v2 v2.2.1-0.20220620205817-bbf835995263/go.mod"
	"github.com/fhs/gompd/v2 v2.3.0"
	"github.com/fhs/gompd/v2 v2.3.0/go.mod"
	"github.com/gotk3/gotk3 v0.6.1"
	"github.com/gotk3/gotk3 v0.6.1/go.mod"
	"github.com/gotk3/gotk3 v0.6.2"
	"github.com/gotk3/gotk3 v0.6.2/go.mod"
	"github.com/op/go-logging v0.0.0-20160315200505-970db520ece7"
	"github.com/op/go-logging v0.0.0-20160315200505-970db520ece7/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
	)
go-module_set_globals

DESCRIPTION="GTK client for Music Player Daemon written in Go"
HOMEPAGE="https://yktoo.com/en/software/ymuse/ https://github.com/yktoo/ymuse/"
SRC_URI="https://github.com/yktoo/ymuse/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

src_compile() {
	ego build
}

src_install() {
	dobin ymuse

	domenu resources/com.yktoo.ymuse.desktop

	insinto /usr/share/metainfo/
	doins resources/metainfo/com.yktoo.ymuse.metainfo.xml

	insinto /usr/share/locale/
	doins -r resources/i18n/*

	insinto /usr/share/icons/
	doins -r resources/icons/*

	dodoc README.md
}
