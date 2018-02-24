Openwrt Buildscripts for Meshkit
=================================

These scripts build the Openwrt firmware for Meshkit usage. Its basically the openwrt
imagebuilder plus a few necessary patches and some extra feeds.

Für den Einsatz vom Meshkit wird der Openwrt Imagebuilder benötigt. Diese Scripte bauen diesen inkl. einiger weniger Patches und zusätzlichen Software-Pakete.

Alternativ kann auch der Imagebuilder aus dem openwrt trunk genommen werden:
https://downloads.openwrt.org/snapshots/trunk/ar71xx/generic/OpenWrt-ImageBuilder-ar71xx-generic.Linux-x86_64.tar.bz2

CC
--

to be used at http://testing.meshkit.freifunk.net
For configuration see config.sh and the comments there:

$ sh ~/buildscripts/CC/prepare.sh -s git://git.openwrt.org/15.05/openwrt.git -d chaos_calmer

$ cd chaos_calmer

$ sh ~/buildscripts/CC/build.sh -t ar71xx

lede-17.01
----------

Build scripts for LEDE-17.01 images. For usage see section CC.

Leipzig
-------

beware, you need at least 40GB HDD Space on building maschine!
used at http://firmware.leipzig.freifunk.net

$ buildall-x86-kvm.sh

$ make IGNORE_ERRORS=m

$ make IGNORE_ERRORS=m














