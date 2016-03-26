# update a current buildroot:
# - openwrt
# - feeds
# - rewrite openwrt release information

# Include functions and config
SCRIPTDIR=$(cd `dirname $0` && pwd)
. $SCRIPTDIR/config.sh
. $SCRIPTDIR/lib/functions.sh
get_target
get_release

echo "TARGET: $TARGET"
echo "RELEASE: $RELEASE"

git checkout
if [ $? -gt 0 ]; then
    echo "Error updating the git respository"
    exit 1
fi

feeds_update $1

make target/linux/clean
make package/opkg/clean
make package/luci/clean

