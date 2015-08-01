# Can take 2 optional argument.
# 1: If this is all, then all packages from the openwrt feed are installed
# 2: OpenWrt revision to upgrade to

# Include functions and config
SCRIPTDIR=$(cd `dirname $0` && pwd)
. $SCRIPTDIR/config.sh
. $SCRIPTDIR/lib/functions.sh
get_target
get_release

if [ -n "$2" ]; then
	svn up -r $2
else
	svn up
fi

feeds_update $1

# Get revision again because buildroot may have been updated
REV=$(svn info -r COMMITTED | awk '/^Revision:/ { print $2 }')
update_openwrt_release

make target/linux/clean
make package/opkg/clean
make package/luci/clean

