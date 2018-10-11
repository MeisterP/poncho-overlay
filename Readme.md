poncho-overlay [![pipeline status](https://0xacab.org/Poncho/poncho-overlay/badges/master/pipeline.svg)](https://0xacab.org/Poncho/poncho-overlay/commits/master)
--------------

This is a Gentoo overlay for packages not in the main tree.
The ebuilds are written by myself or copied from other peoples overlays.

The poncho-overlay isn't in layman’s list of overlays. To add it manually, drop
`https://raw.github.com/MeisterP/poncho-overlay/master/poncho-overlay.xml`
into `/etc/layman/overlays/` and run `layman -a poncho`

Or you can use `eselect repository add poncho git https://github.com/MeisterP/gnome-overlay.git`.
