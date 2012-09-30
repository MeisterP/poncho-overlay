# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit check-reqs eutils games unpacker

MY_PN="${PN//-/_}"
MY_REV="-3"
MY_ARCH="${ARCH/amd64/x86_64}"

DESCRIPTION="A first person survival horror game about immersion, discovery and living through a nightmare."
HOMEPAGE="http://www.amnesiagame.com/"
SRC_URI="${MY_PN}-${PV}${MY_REV}.sh"

RESTRICT="fetch strip"
LICENSE="Frictional_Games-EULA"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc linguas_de linguas_es linguas_fr linguas_it linguas_ru"

DEPEND="app-arch/xz-utils"
RDEPEND="media-libs/freealut
	>=media-libs/glew-1.5
	media-libs/jpeg:62
	media-libs/libpng:1.2
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl-image
	media-libs/sdl-ttf
	sys-libs/zlib
	x11-libs/libxcb
	x11-libs/libXext
	virtual/glu
	virtual/opengl"

CHECKREQS_DISK_BUILD="3500M"

S="${WORKDIR}/${PN}"

GAMEDIR="${GAMES_PREFIX_OPT}/${PN}"

pkg_nofetch() {
	einfo ""
	einfo "Please buy and download \"${SRC_URI}\" from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move/link it to \"${DISTDIR}\""
	einfo ""
}

pkg_setup() {
	games_pkg_setup
}

src_unpack() {
	einfo "\nUnpacking files.  This will take several minutes.\n"
	mkdir "${S}" || die "mkdir "${S}" failed"
	cd "${S}" || die "cd '${S}' failed"

	unpack_makeself || die "unpack_makeself failed"

	mv "instarchive_all" "../${P}.tar.lzma" || die "move 'instarchive_all' failed"
	mv "instarchive_all_${MY_ARCH}" "../${P}-${MY_ARCH}.tar.lzma" || die "move 'instarchive_all_${MY_ARCH}' failed"

	cd "${WORKDIR}" || die "cd '${WORKDIR}' failed"

	echo ">>> Unpacking ./${P}.tar.lzma to ${WORKDIR}"
	#Standard unpack fails due to poor quality of archive
	xz -F lzma -d -c "./${P}.tar.lzma" 2>/dev/null | tar xf - || die "unpacking '${P}.tar.lzma' failed"
	rm "./${P}.tar.lzma"

	unpack "./${P}-${MY_ARCH}.tar.lzma" || die "unpack '${P}-${MY_ARCH}.tar.lzma' failed"
	rm "./${P}-${MY_ARCH}.tar.lzma"
}

src_prepare() {
	# libfltk.so.1.1 is needed because it's no longer in portage
	mv "${WORKDIR}"/Amnesia/libs*/all/libfltk* "${WORKDIR}"/Amnesia/libs*/ || die "libfltk extraction failed"

	#reset ${S} for outprocessing
	rm -rf "${S}"
	mv "${WORKDIR}/Amnesia" "${S}" || die "mv 'Amnesia' failed"
	cd "${S}"

	# Files to remove.
	REMOVE="libs*/*
		*.pdf
		*.rtf
		*.sh"

	# Files to keep.
	# Bundled LibIL (media-libs/devil) isn't in portage as too old
	KEEP="libs*/libIL*
		libs*/libfltk*"

	# Collect infos about languages...
	LINGUAS_ARRAY=()		# Linguas - string: E.g.: "linguas_en"
	LANG_ARRAY=()			# Lang - string: E.g.: "en"
	LANGUAGE_ARRAY=()		# Language - string: E.g.: "english"
	LANGUAGE_SHORT_ARRAY=()		# Language Short - string: E.g.: "eng"
	USE_ARRAY=()			# Used - bool (0,1)

	local linguas_in_use="0"
	for use in ${IUSE}
	do
		if [[ "${use%%_*}" == "linguas" ]]
		then
			local tmp="${use}"
			LINGUAS_ARRAY=(${LINGUAS_ARRAY[@]} "${tmp}")

			tmp="${tmp##linguas_}"
			LANG_ARRAY=(${LANG_ARRAY[@]} "${tmp}")

			case "${tmp}" in
				"de") tmp="german";;
				"es") tmp="spanish";;
				"fr") tmp="french";;
				"it") tmp="italian";;
				"ru") tmp="russian";;
				*) tmp="";;
			esac
			LANGUAGE_ARRAY=(${LANGUAGE_ARRAY[@]} "${tmp}")
			LANGUAGE_SHORT_ARRAY=(${LANGUAGE_SHORT_ARRAY[@]} "${tmp:0:3}")

			if use ${use}
			then
				USE_ARRAY=(${USE_ARRAY[@]} "1")
				linguas_in_use="$(( ${linguas_in_use} + 1 ))"
			else
				USE_ARRAY=(${USE_ARRAY[@]} "0")
			fi
		fi
	done

	# ...then process them.
	local n="0"
	local docs_eng="0"
	while [[ "${n}" -lt "${#LINGUAS_ARRAY[@]}" ]]
	do
		if [[ "${USE_ARRAY[${n}]}" -gt "0" ]]
		then
			# If only one lang is selected, use it as default.
			if [[ "${linguas_in_use}" == "1" ]]
			then
				sed -e "s#english.lang#${LANGUAGE_ARRAY[${n}]}.lang#g" \
				    -i config/*main_init.cfg || die "sed \"config/*main_init.cfg\" failed"
			fi
		else
			REMOVE="${REMOVE} $(find config -type f -name "*${LANGUAGE_ARRAY[${n}]}.lang")"
			if [[ -d "lang/${LANGUAGE_SHORT_ARRAY[${n}]}" ]]
			then
				REMOVE="${REMOVE} lang/${LANGUAGE_SHORT_ARRAY[${n}]}"
			fi
		fi

		if use doc
		then
			if [[ -f "EULA_${LANG_ARRAY[${n}]}.rtf" && -f "Manual_${LANG_ARRAY[${n}]}.pdf" ]]
			then
				KEEP="${KEEP} EULA_${LANG_ARRAY[${n}]}.rtf Manual_${LANG_ARRAY[${n}]}.pdf"
			else
				local docs_eng="1"
			fi
		fi

		n="$(( ${n} + 1 ))"
	done

	if use doc && [[ ( "${linguas_in_use}" == "0" || "${docs_eng}" != "0" ) ]]
	then
		KEEP="${KEEP} EULA_en.rtf Manual_en.pdf Remember*.pdf"
	fi

	einfo " Removing useless files ..."
	for remove in ${REMOVE}
	do
		local removable="1"
		for keep in ${KEEP}
		do
			if [[ "${remove}" == "${keep}" && "${removable}" == "1" ]]
			then
				local removable="0"
			fi
		done

		if [[ "${removable}" == "1" ]]
		then
			rm -r "${S}/"${remove} &> /dev/null
		fi
	done

	if use amd64
	then
		mv "Amnesia.bin64" "Amnesia.bin" || die "mv \"Amnesia.bin64\" failed"
		mv "Launcher.bin64" "Launcher.bin" || die "mv \"Launcher.bin64\" failed"
	fi
}

src_install() {
	# Install data
	insinto "${GAMEDIR}"

	einfo " Installing game data files ..."
	for directory in $(find * -maxdepth 0 -type d ! -name "libs*")
	do
		doins -r ${directory} || die "doins game data files failed"
	done

	# Other files
	find . -maxdepth 1 -type f ! -name "*.bin" \
				   ! -name "*.pdf" \
				   ! -name "*.png" \
				   ! -name "*.rtf" \
				   ! -name "*.sh" \
				   -exec doins '{}' \; || die "doins other files failed"

	# Install libraries and executables
	einfo " Installing libraries and executables ..."

	if use amd64
	then
		local libsdir="${GAMEDIR}/libs64"
	else
		local libsdir="${GAMEDIR}/libs"
	fi

	exeinto "${libsdir}"
	doexe libs*/* || die "doexe \"libs\" failed"
	dosym "/usr/$(get_libdir)/libGLEW.so" "${libsdir}/libGLEW.so.1.5"

	exeinto "${GAMEDIR}"
	doexe *.bin || die "doexe \".bin\" binaries failed"

	# Make game wrapper
	local wrapper="${S}/${PN}"
	local ext="${PN}-justine"

	cat << EOF > "${wrapper}" || die "echo failed"
#!/bin/sh
if [[ "\$(basename "\${0}")" == "${ext}" ]]
then
	params="ptest \${@}"
fi

if [[ -w "\${HOME}/.frictionalgames/Amnesia/Main/main_settings.cfg" ]]
then
	exec /opt/amnesia-tdd/Amnesia.bin \${params:-"\${@}"}
else
	exec /opt/amnesia-tdd/Launcher.bin "\${@}"
fi
EOF

	# Install wrapper
	dogamesbin "${wrapper}" || die "dogamesbin ${wrapper} failed"
	dosym "${PN}" "${GAMES_BINDIR}/${ext}"

	# Install icon and desktop file
	newicon "Amnesia.png" "${PN}.png" || die "newicon failed"
	make_desktop_entry "${PN}" "Amnesia: The Dark Descent" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"
	make_desktop_entry "${ext}" "Amnesia: The Dark Descent - Justine" "/usr/share/pixmaps/${PN}.png" || die "make_desktop_entry failed"

	# Install documentation
	if use doc
	then
		dodoc *.rtf *.pdf || die "dodoc failed"
	fi

	# Setting permissions.
	einfo " Setting permissions ..."
	prepgamesdirs
}

pkg_postinst() {
	ewarn ""
	ewarn "Amnesia: The Dark Descent needs video drivers that provide a complete".
	ewarn "GLSL 1.20 implementation.  For more information, please visit:"
	ewarn "http://www.frictionalgames.com/forum/thread-3760.html"
	ewarn ""
	ewarn "--------------------------------------------------------------------"
	ewarn ""
	ewarn "Saved games from previous versions may not be fully compatible."
	ewarn ""
}
