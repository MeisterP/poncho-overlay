#!/sbin/runscript
# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header:

start() {
	ebegin "Starting Logkeys"

	start-stop-daemon \
		--start \
		--pidfile /var/run/logkeys.pid \
		--exec /usr/bin/logkeys -- -s ${LOGKEYS_ARGS}
	eend $?
}

stop() {
	ebegin "Stopping Logkeys"
	start-stop-daemon --stop --pidfile /var/run/logkeys.pid
	eend $?
}
