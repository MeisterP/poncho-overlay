# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit check-reqs eutils games unpacker

MY_PN="${PN//-/_}"
MY_ARCH="${ARCH/amd64/x86_64}"

DESCRIPTION="Amnesia: The Dark Descent is a first person survival horror. A game about immersion, discovery and living through a nightmare."
HOMEPAGE="http://www.amnesiagame.com/"
SRC_URI="${MY_PN}_${PV}.sh"

RESTRICT="fetch strip"
LICENSE="Frictional_Games-EULA"

SLOT="0"
KEYWORDS="amd64 x86"
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
	#x11-libs/fltk:1

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
	einfo "arch = $ARCH"
	return
}

src_unpack() {
	# Check if we have enough space for unpack:
	CHECKREQS_DISK_BUILD="3500M"
	check-reqs_pkg_setup

	einfo "\nUnpacking files.  This will take several minutes.\n"

	mkdir "tmp" || die "mkdir 'tmp' failed"
	cd "./tmp" || die "cd 'tmp' failed"

	unpack_makeself || die "unpack_makeself failed"

	mv "subarch" "installer.tar.lzma" || die "move 'subarch' failed"
	unpack "./installer.tar.lzma" || die "unpack 'installer.tar.lzma' failed"

	mv "instarchive_all" "../${P}.tar.lzma" || die "move 'instarchive_all' failed"
	mv "instarchive_all_${MY_ARCH}" "../${P}-${MY_ARCH}.tar.lzma" || die "move 'instarchive_all_${MY_ARCH}' failed"
	mv "icon.xpm" "../${PN}.xpm" || die "mv 'icon.xml' failed"

	cd "${WORKDIR}" || die "cd '${WORKDIR}' failed"
	rm -rf "./tmp"

	unpack "./${P}.tar.lzma" || die "unpack '${P}.tar.lzma' failed"
	rm "./${P}.tar.lzma"

	unpack "./${P}-${MY_ARCH}.tar.lzma" || die "unpack '${P}-${MY_ARCH}.tar.lzma' failed"
	rm "./${P}-${MY_ARCH}.tar.lzma"

	mv "Amnesia" "${PN}" || die "mv 'Amnesia' failed"

	# libfltk.so.1.1 is needed because it's no longer in portage
	einfo "PWD = $PWD"
	mv "${S}"/libs*/all/libfltk* "${S}"/libs*/
}

src_prepare() {
	# Files to remove.
	REMOVE="libs*/*
		*.pdf
		*.png
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

	exeinto "${libsdir}" || die "exeinto \"${libsdir}\" failed"
	doexe libs*/* || die "doexe \"libs\" failed"

	dosym "/usr/$(get_libdir)/libGLEW.so" "${libsdir}/libGLEW.so.1.5"
	#dosym "/usr/$(get_libdir)/fltk-1/libfltk.so" "${libsdir}/libfltk.so.1.1"

	exeinto "${GAMEDIR}" || die "exeinto \"${GAMEDIR}\" failed"
	doexe *.bin || die "doexe \".bin\" binaries failed"


	# Make game wrapper
	dodir "${GAMES_BINDIR}" || die "dodir \"${GAMES_BINDIR}\" failed"

	local wrapper="${D}/${GAMES_BINDIR}/${PN}"
	local ext="${PN}-justine"
	touch "${wrapper}" || die "touch \"${wrapper}\" failed"
	ln -s "${wrapper}" "${D}/${GAMES_BINDIR}/${ext}" || die "ln -s \"${ext}\" failed"

	cat << EOF >> "${wrapper}" || die "echo failed"
#!/bin/sh
cd "${GAMEDIR}"

if [[ "\$(basename "\${0}")" == "${ext}" ]]
then
  params="ptest \${@}"
fi

if [[ -w "\${HOME}/.frictionalgames/Amnesia/Main/main_settings.cfg" ]]
then
  exec ./Amnesia.bin \${params:-"\${@}"}
else
  exec ./Launcher.bin "\${@}"
fi
EOF


	# Install icon and desktop file
	local icon="${PN}.xpm"
	doicon "../${icon}" || die "newicon \"${icon}\" failed"
	make_desktop_entry "${PN}" "Amnesia: The Dark Descent" "/usr/share/pixmaps/${icon}" || die "make_desktop_entry failed"
	make_desktop_entry "${ext}" "Amnesia: The Dark Descent - Justine" "/usr/share/pixmaps/${icon}" || die "make_desktop_entry failed"


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
