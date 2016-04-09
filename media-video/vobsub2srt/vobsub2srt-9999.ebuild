# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="Converts VobSub subtitles (.idx/.srt format) into .srt subtitles."
HOMEPAGE="https://github.com/ruediger/VobSub2SRT"
EGIT_REPO_URI="git://github.com/ruediger/VobSub2SRT.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-text/tesseract-2.04-r1
	>=virtual/ffmpeg-0.6.90"
RDEPEND="${DEPEND}"
