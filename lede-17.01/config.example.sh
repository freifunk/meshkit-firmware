#!/bin/sh

# Patches that are applied to the openwrt sources after the checkout
PATCHES_OPENWRT="./patches/openwrt"

# Patches that will be applied to feeds after all feeds have been checked out
PATCHES_FEEDS="./patches/feeds"

# Distribution name, will be written to CONFIG_VERION_DIST
VERSION_DIST="OpenWrt/Meshkit"

# Version nickname, will be written to CONFIG_VERION_NICK
VERSION_NICK="Chaos Calmer Meshkit"

# this is the base url to use for package downloads in opkg.conf
# make the compiled packages available there in a structure like:
# /<target>/<subtarget>/<release>/packages/, e.g.:
# /ar71xx/generic/chaos_calmer-r46177/packages//Packages.gz
REPO_BASEURL="http://dl.meshkit.freifunk.net"

# Doanloaded source packages are stored in this folder
DOWNLOAD_FOLDER="/data/download"

# Cores to use for compiling (-j make option)
CORES=8

# CCache may be enabled here
USE_CCACHE=1

# Build the SDK
BUILD_SDK=0

# Enable verbose output for make
VERBOSE_MAKE=1

# IGNORE_ERRORS paremeter (m is useful when building all)
IGNORE_ERRORS="m"
