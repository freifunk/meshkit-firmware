# build imagebuilder with all packages for a given platform
#REMOTE=git://git.openwrt.org/openwrt.git
#TARGET=ar71xx

# in case of oxnas, also use oxnas remote site
REMOTE=git://git.openwrt.org/openwrt.git
TARGET=oxnas

# MAKEOPTS="-j4"

# fail on errors
set +e

git clone $REMOTE openwrt

# if [ ! -d openwrt-oxnas ]; then
# git clone $REMOTE openwrt-oxnas
# else
# ( cd openwrt-oxnas;
# git fetch origin;
# git checkout origin/master;
# git branch -D master;
# git checkout -b master; );
# fi



cd openwrt
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
echo "src-git solarfestival git://github.com:freifunk/freifunk-leipzig/solarfestival-packages.git" >> feeds.conf
#echo "src-git oldpackages http://git.openwrt.org/packages.git" >> feeds.conf

scripts/feeds update -a

# create index and install all packages
scripts/feeds update -i
scripts/feeds install -a

# create default config for given platform
cat >.config <<EOF
CONFIG_MODULES=y
CONFIG_HAVE_DOT_CONFIG=y
CONFIG_TARGET_oxnas=y
CONFIG_TARGET_oxnas_STG212=y
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
CONFIG_SDK=y
CONFIG_COLLECT_KERNEL_DEBUG=y
CONFIG_BUILD_PATENTED=y
CONFIG_KERNEL_KALLSYMS=y
CONFIG_KERNEL_DEBUG_KERNEL=y
CONFIG_KERNEL_DEBUG_INFO=y
CONFIG_PACKAGE_kmod-ath=m
CONFIG_ATH_USER_REGD=y
CONFIG_PACKAGE_ATH_DEBUG=y
CONFIG_VERSIONOPT=y
CONFIG_VERSION_DIST="OpenWrt"
CONFIG_VERSION_NICK=""
CONFIG_VERSION_NUMBER=""
CONFIG_VERSION_REPO="http://firmware.leipzig.freifunk.net:8006/firmware/buildroots/oxnas_20140625oxnas/packages"
CONFIG_PACKAGE_collectd-mod-netlink=n
CONFIG_PACKAGE_kmod-pcspkr=n
CONFIG_SENSORS_VEXPRESS=m
# CONFIG_TARGET_ROOTFS_INITRAMFS is not set
# CONFIG_TARGET_INITRAMFS_COMPRESSION_NONE is not set
CONFIG_KERNEL_PERF_EVENTS=y
CONFIG_KERNEL_KEXEC=y
CONFIG_KERNEL_CGROUPS=y
# CONFIG_KERNEL_CGROUP_DEBUG is not set
CONFIG_KERNEL_FREEZER=y
CONFIG_KERNEL_CGROUP_FREEZER=y
CONFIG_KERNEL_CGROUP_DEVICE=y
# CONFIG_KERNEL_CPUSETS is not set
CONFIG_KERNEL_CGROUP_CPUACCT=y
CONFIG_KERNEL_RESOURCE_COUNTERS=y
CONFIG_KERNEL_MM_OWNER=y
CONFIG_KERNEL_MEMCG=y
CONFIG_KERNEL_MEMCG_SWAP=y
CONFIG_KERNEL_MEMCG_SWAP_ENABLED=y
CONFIG_KERNEL_MEMCG_KMEM=y
CONFIG_KERNEL_CGROUP_PERF=y
# CONFIG_KERNEL_CGROUP_SCHED is not set
CONFIG_KERNEL_BLK_CGROUP=y
# CONFIG_KERNEL_DEBUG_BLK_CGROUP is not set
CONFIG_KERNEL_NET_CLS_CGROUP=y
CONFIG_KERNEL_NETPRIO_CGROUP=y
CONFIG_KERNEL_NAMESPACES=y
CONFIG_KERNEL_UTS_NS=y
CONFIG_KERNEL_IPC_NS=y
CONFIG_KERNEL_USER_NS=y
CONFIG_KERNEL_PID_NS=y
CONFIG_KERNEL_NET_NS=y
CONFIG_KERNEL_LXC_MISC=y
CONFIG_KERNEL_DEVPTS_MULTIPLE_INSTANCES=y
CONFIG_KERNEL_POSIX_MQUEUE=y
EOF

make defconfig

# allow stuff to fail from here on
set -e

echo # make everything with
echo #make $MAKEOPTS IGNORE_ERRORS=m V=99 BUILD_LOG=1
echo dont forget to set batman-adv devel version git commit number manually if you need that
