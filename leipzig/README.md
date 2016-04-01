Buildscripts for Meshkit Firmware
=================================

These scripts build the Meshkit firmware, which is basically the openwrt
imagebuilder plus a few necessary patches and some extra feeds.

For configuration see config.sh and the comments there.

Prepare
-------

To start with a fresh build, prepare the buildroot first (checkout sources etc):

$ sh ~/buildscripts/CC/prepare.sh -s svn://svn.openwrt.org/openwrt/branches/chaos_calmer -d chaos_calmer

This should checkout openwrt from svn. Yes, svn. We need that to get clean
version numbers for the builds.

Build imagebuilder
------------------

Then change to the destination directory, e.g.

$ cd chaos_calmer

After that, start a build:

$ sh ~/buildscripts/CC/build.sh -t ar71xx













