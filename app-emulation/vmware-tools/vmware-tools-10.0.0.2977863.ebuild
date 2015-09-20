# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit versionator vmware-bundle

MY_PV="$(replace_version_separator 3 - $PV)"
#BASE_URI="https://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/$(get_version_component_range 4)/linux/packages/"
BASE_URI="https://softwareupdate.vmware.com/cds/vmw-desktop/ws/12.0.0/2985596/linux/packages/"

DESCRIPTION="VMware Tools for guest operating systems"
HOMEPAGE="http://www.vmware.com/"

LICENSE="vmware"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="mirror"
IUSE=""

DEPEND=""
RDEPEND=""

IUSE_VMWARE_GUEST="freebsd linux netware solaris windows winPre2k"

VM_INSTALL_DIR="/opt/vmware"

for guest in ${IUSE_VMWARE_GUEST} ; do
	SRC_URI+=" vmware_guest_${guest}? (
		${BASE_URI}vmware-tools-${guest}-${MY_PV}.x86_64.component.tar
		)"
	IUSE+=" vmware_guest_${guest}"
done ; unset guest

src_unpack() {
	local arch='x86_64'
	local guest ; for guest in ${IUSE_VMWARE_GUEST} ; do
		if use "vmware_guest_${guest}" ; then
			local component="vmware-tools-${guest}-${MY_PV}.${arch}.component"
			unpack "${component}.tar"
			vmware-bundle_extract-component "${component}"
		fi
	done
}

src_install() {
	insinto "${VM_INSTALL_DIR}"/lib/vmware/isoimages
	local guest ; for guest in ${IUSE_VMWARE_GUEST} ; do
		if use "vmware_guest_${guest}" ; then
			doins "${guest}".iso{,.sig}
		fi
	done
}
