# build imagebuilder with all packages for a given platform
REMOTE=git://git.openwrt.org/openwrt.git
TARGET=ar71xx
#TARGET=x86
# TARGET=ramips

# in case of oxnas, also use oxnas remote site
# REMOTE=git://gitorious.org/openwrt-oxnas/openwrt-oxnas.git
# TARGET=oxnas

# MAKEOPTS="-j4"

# fail on errors
set +e

git clone $REMOTE openwrt
cd openwrt
rm -rf feeds/routing*
cp feeds.conf.default feeds.conf
echo "src-git luci2 http://git.openwrt.org/project/luci2/ui.git" >> feeds.conf
#echo "src-git cjdns git://github.com/lgierth/cjdns-openwrt.git" >> feeds.conf
echo "src-git cjdns git://github.com/seattlemeshnet/meshbox.git" >> feeds.conf
echo "src-git fastd git://git.metameute.de/lff/pkg_fastd" >> feeds.conf
echo "src-git mwan3 git://github.com/Adze1502/mwan.git" >> feeds.conf
echo "src-git batmanadv http://git.open-mesh.org/openwrt-feed-batman-adv.git" >> feeds.conf
echo "src-git wbm git://github.com/battlemesh/battlemesh-packages.git" >> feeds.conf
echo "src-git libreage git://github.com/libremap/libremap-agent-openwrt.git" >> feeds.conf
echo "src-git kadnode git://github.com/mwarning/KadNode.git" >> feeds.conf
echo "src-git kadlibsodium git://github.com/mwarning/libsodium-openwrt.git" >> feeds.conf
echo "src-git fswebcam git://github.com/fsphil/fswebcam.git" >> feeds.conf
echo "src-git oldpackages http://git.openwrt.org/packages.git" >> feeds.conf

scripts/feeds update -a

# revert to batman-adv 2013.4.0
# cd feeds/routing
# git remote add github-routing git://github.com/openwrt-routing/packages.git
# git fetch github-routing
# git checkout -b batman-adv-backport
# rm -r batman-adv
# git checkout 89c2a8bb562412281d1ff070007be16d5a4d8f55 batman-adv
# git commit -a -m "batman-adv: revert to 2013.4.0"
# rm -r alfred
# git checkout e2cfab7f287673b1d6854c59db6e710668d145f3 alfred
# git commit -a -m "alread: revert to 2013.4.0"
# cd ../..

# create index and install all packages
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
CONFIG_IMAGEOPT=y
CONFIG_DEVEL=y
CONFIG_NEED_TOOLCHAIN=y
CONFIG_TOOLCHAINOPTS=y
CONFIG_SSP_SUPPORT=y
CONFIG_IB=y
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
CONFIG_VERSION_REPO="http://rund.freifunk.net:8006/firmware/buildroots/ar71xx_generic_20140611/packages"
CONFIG_PACKAGE_collectd-mod-netlink=n
CONFIG_PACKAGE_kmod-pcspkr=n
EOF

make defconfig

# allow stuff to fail from here on
set -e

# make everything
#make $MAKEOPTS IGNORE_ERRORS=m V=99 BUILD_LOG=1
echo dont forget to set batman-adv devel version git commit number manually (batman-adv bug/fix needed!!!)
