#!/bin/bash
# prepare the buidroot - checkout sources, patch

SCRIPTDIR=$(cd `dirname $0` && pwd)
test -f $SCRIPTDIR/config.sh || {
    echo "Can not load config file, please create it."
    exit 1
}
. $SCRIPTDIR/config.sh

test -f $SCRIPTDIR/lib/functions.sh || {
    echo "Can not load functions.sh."
    exit 1
}
. $SCRIPTDIR/lib/functions.sh

print_help() {
        cat << EOF

$0 usage
This script will checkout openwrt from git and feeds from their own
repositories. After that patches are applied.

Example:
  sh prepare.sh -s git://git.openwrt.org/15.05/openwrt.git -d chaos_calmer

OPTIONS:
  -d	destination, should be the branch name, e.g. chaos_calmer (required)
  -h	show this help
  -s    OpenWrt sources from git repository (required)

EOF
}

while getopts d:hs: opt; do
   case $opt in
       d) DST="$OPTARG";;
       h) print_help; exit 1;;
       s) SOURCE="$OPTARG";;
   esac
done

if [ -z "$SOURCE" ] || [ -z "$DST" ]; then
	err "Missing arguments. -d and -s are required."
	print_help;
	exit 1
fi

[ -d $DST ] && {
	err "Error: The directory $DST already exists, exiting."
	exit 1
}


# checkout openwrt, patch openwrt, checkout feeds, patch feeds

git clone $SOURCE $DST

if [ "$?" -eq 0 ]; then
	e "Checkout succeeded."
	cd $DST
	# patch openwrt sources
	apply_patches openwrt $SCRIPTDIR/$PATCHES_OPENWRT
	if [ $? -ne 0 ]; then
		err "Applying patches to openwrt failed. Please check your patches and try again"
		exit 1
	fi

	# Checkout feeds and install all packages
	feeds_update all

	apply_patches feeds $SCRIPTDIR/$PATCHES_FEEDS

else
	err "There was a problem checking out the source from svn, aborted."
	exit 1
fi
