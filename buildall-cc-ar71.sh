# build imagebuilder with all packages for a given platform
REMOTE=git://git.openwrt.org/15.05/openwrt.git
TARGET=ar71xx
#TARGET=x86

# fail on errors
set +e

git clone $REMOTE openwrt
cd openwrt
cp feeds.conf.default feeds.conf
echo "src-git luci2 http://git.openwrt.org/project/luci2/ui.git" >> feeds.conf
#echo "src-git cjdns git://github.com/seattlemeshnet/meshbox.git" >> feeds.conf
echo "src-git cjdns git://github.com/seattlemeshnet/meshbox.git" >> feeds.conf
#echo "src-git fastd git://git.metameute.de/lff/pkg_fastd" >> feeds.conf
echo "src-git mwan3 git://github.com/Adze1502/mwan.git" >> feeds.conf
#echo "src-git batmanadv http://git.open-mesh.org/openwrt-feed-batman-adv.git" >> feeds.conf
echo "src-git wbm git://github.com/battlemesh/battlemesh-packages.git" >> feeds.conf
echo "src-git libreage git://github.com/libremap/libremap-agent-openwrt.git" >> feeds.conf
echo "src-git kadnode git://github.com/mwarning/KadNode.git" >> feeds.conf
echo "src-git kadlibsodium git://github.com/mwarning/libsodium-openwrt.git" >> feeds.conf
echo "src-git fswebcam git://github.com/fsphil/fswebcam.git" >> feeds.conf
echo "src-git solarfestival git://github.com/freifunk-leipzig/solarfestival-packages.git" >> feeds.conf
#echo "src-git oldpackages http://git.openwrt.org/packages.git" >> feeds.conf

# create index and install all packages
scripts/feeds update -a


revert to batman-adv 2015.2.0
cd feeds/routing
git remote add github-routing git://github.com/openwrt-routing/packages.git
git fetch github-routing
git checkout -b batman-adv-backport
rm -r batman-adv
git checkout 0db26614ecdc60dfed4403374bc9e95586dd3d17 batman-adv
git commit -a -m "batman-adv: revert to 2015.2.0"
rm -r alfred
git checkout e25839ae48cfdb44015be5f47d409182cea8c7d2 alfred
git commit -a -m "alread: revert to 2015.2.0"
rm -r batctl
git checkout f8380b4136b2b030b3f7df233cb603214a953399 batctl
git commit -a -m "batctl: revert to 2015.2.0"
cd ../..


scripts/feeds update -i
scripts/feeds install -a

# create default config for given platform
cat >.config <<EOF
CONFIG_MODULES=y
CONFIG_HAVE_DOT_CONFIG=y
CONFIG_TARGET_${TARGET}=y
# CONFIG_TARGET_ROOTFS_EXT4FS is not set
# CONFIG_TARGET_ROOTFS_JFFS2 is not set
CONFIG_TARGET_ROOTFS_SQUASHFS=y
# CONFIG_TARGET_ROOTFS_INCLUDE_UIMAGE is not set
# CONFIG_TARGET_ROOTFS_INCLUDE_ZIMAGE is not set
CONFIG_ALL=y
CONFIG_ALL_KMODS=y
CONFIG_IMAGEOPT=y
CONFIG_DEVEL=y
CONFIG_NEED_TOOLCHAIN=y
CONFIG_TOOLCHAINOPTS=y
#CONFIG_SSP_SUPPORT=y
CONFIG_IB=y
CONFIG_SDK=y
CONFIG_COLLECT_KERNEL_DEBUG=y
CONFIG_BUILD_PATENTED=y
CONFIG_KERNEL_KALLSYMS=y
CONFIG_KERNEL_DEBUG_KERNEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_PACKAGE_kmod-ath=y
CONFIG_ATH_USER_REGD=y
CONFIG_PACKAGE_ATH_DEBUG=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="OpenWrt"
CONFIG_VERSION_NICK=""
CONFIG_VERSION_NUMBER=""
CONFIG_VERSION_REPO="http://firmware.leipzig.freifunk.net:8006/firmware/buildroots/ar71xx_generic_20151127cc/packages"
CONFIG_PACKAGE_collectd-mod-netlink=n
CONFIG_PACKAGE_kmod-pcspkr=n
EOF

make defconfig

# allow stuff to fail from here on
set -e

echo # make everything with
echo #make $MAKEOPTS IGNORE_ERRORS=m V=99 BUILD_LOG=1
echo #please do it within screen###
echo make IGNORE_ERRORS=m
