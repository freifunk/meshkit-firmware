#!/bin/sh
# sh build.sh ar71xx/generic -h to show the help
# Default target is ar71xx

SCRIPTDIR=$(cd `dirname $0` && pwd)
BRANCH=$(pwd | sed 's/\/.*\///')

# include config options and functions
. $SCRIPTDIR/config.sh
. $SCRIPTDIR/lib/functions.sh

print_help() {
	cat << EOF

$0 usage
Build openwrt and imagebuilder.

OPTIONS:
  -a	Build all packages (Default: no)
  -h	Show this help
  -j	Number of cores to use for make (Default: from config file)
  -s	Subtarget (Default: empty)
  -t	Target (Default: ar71xx)

EOF
}

while getopts ahj:s:t: opt; do
   case $opt in
       a) BUILD_ALL=1;;
       h) print_help; exit 1;;
       j) CORES="$OPTARG";;
       s) SUBTARGET="$OPTARG";;
       t) TARGET="$OPTARG";;
   esac
done

get_release
get_revision

# Set the choosen target
[ -z "$TARGET" ] && TARGET="ar71xx"

# switch to environment or create a new one
if [ -n "$SUBTARGET" ]; then
	ENVIRONMENT="${TARGET}_${SUBTARGET}-r${REV}"
else
	ENVIRONMENT="${TARGET}-r${REV}"
fi

if [ -n "$(./scripts/env list |grep $ENVIRONMENT)" ]; then
	./scripts/env switch $ENVIRONMENT
else
	echo "Y" | ./scripts/env new $ENVIRONMENT
fi

# clean bin dir
[ -d bin/$TARGET ] && {
	rm -rf bin/$TARGET/*
	e "Cleanup: Deleted all files in bin/$TARGET"
}

e "Target: $TARGET"
[ -n "$SUBTARGET" ] && e "Subtarget: $SUBTARGET"

echo "CONFIG_TARGET_${TARGET}=y" > .config

# Do basic configuration
# CONFIG_STRIP_KERNEL_EXPORTS will save some space by stripping unneeded functions from the kernel.

echo "CONFIG_DEVEL=y
CONFIG_IB=y
CONFIG_ALL_KMODS=y
CONFIG_ATH_USER_REGD=y
CONFIG_IMAGEOPT=y
CONFIG_VERSIONOPT=y
CONFIG_CCACHE=y
# CONFIG_TARGET_ROOTFS_JFFS2 is not set
CONFIG_STRIP_KERNEL_EXPORTS=y
CONFIG_BUILD_LOG=y
CONFIG_PER_FEED_REPO=n
CONFIG_SIGNED_PACKAGES=n
CONFIG_DOWNLOAD_FOLDER=\"${DOWNLOAD_FOLDER}\"" >> .config

if [ -n "$SUBTARGET" ]; then
	echo "CONFIG_TARGET_${TARGET}_${SUBTARGET}=y" >> .config
fi


# building all packages will take some hours!

if [ "$BUILD_ALL" = 1 ]; then
	e "Building all packages (CONFIG_ALL=y)"
	echo "CONFIG_ALL=y" >> .config
else
	if [ -f $SCRIPTDIR/packages.minimal ]; then
		e "Building minimal package set"
		while read line; do
			echo "CONFIG_PACKAGE_${line}=m" >> .config
			e "Adding:  $line"
		done < $SCRIPTDIR/packages.minimal
	fi
fi

# enable ccache
[ "$USE_CCACHE" = 1 ] && {
	echo "CONFIG_CCACHE=y" >> .config
	e "Using CCACHE"
}

make defconfig

# Update openwrt_release
update_openwrt_release

# Update repositories.conf
gen_repositories_conf

# ready to build!
VMAKE=''
if [ "$VERBOSE_MAKE" = 1 ]; then
	VMAKE="V=s"
fi

./scripts/env save

e "Starting build."
make -j${CORES} $VMAKE IGNORE_ERRORS=${IGNORE_ERRORS}
