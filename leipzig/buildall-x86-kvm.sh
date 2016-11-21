# build imagebuilder with all packages for a given platform
REMOTE=git://github.com/lede-project/source
#REMOTE=git://git.openwrt.org/openwrt.git
#TARGET=ar71xx
TARGET=x86
# TARGET=ramips

# in case of oxnas, also use oxnas remote site
# REMOTE=git://gitorious.org/openwrt-oxnas/openwrt-oxnas.git
# TARGET=oxnas

# MAKEOPTS="-j4"

# fail on errors
set +e

git clone $REMOTE lede
cd lede
cp feeds.conf.default feeds.conf
echo "src-git luci2 http://git.openwrt.org/project/luci2/ui.git" >> feeds.conf
echo "src-git fastd git://git.metameute.de/lff/pkg_fastd" >> feeds.conf
echo "src-git mwan3 git://github.com/Adze1502/mwan.git" >> feeds.conf
#echo "src-git batmanadv http://git.open-mesh.org/openwrt-feed-batman-adv.git" >> feeds.conf
echo "src-git wbm git://github.com/battlemesh/battlemesh-packages.git" >> feeds.conf
echo "src-git libreage git://github.com/libremap/libremap-agent-openwrt.git" >> feeds.conf
echo "src-git kadnode git://github.com/mwarning/KadNode.git" >> feeds.conf
echo "src-git kadlibsodium git://github.com/mwarning/libsodium-openwrt.git" >> feeds.conf
echo "src-git fswebcam git://github.com/fsphil/fswebcam.git" >> feeds.conf
echo "src-git solarfestival git://github.com/freifunk-leipzig/solarfestival-packages.git" >> feeds.conf
#echo "src-git oldpackages http://git.openwrt.org/packages.git" >> feeds.conf

scripts/feeds update -a
scripts/feeds update -i
scripts/feeds install -a

# create default config for given platform
cat >.config <<EOF
CONFIG_MODULES=y
CONFIG_HAVE_DOT_CONFIG=y
CONFIG_TARGET_${TARGET}=y
CONFIG_TARGET_x86_kvm_guest=y
# CONFIG_TARGET_x86_generic is not set
# CONFIG_TARGET_x86_generic_Generic is not set
CONFIG_TARGET_x86_kvm_guest_Default=y
CONFIG_DEFAULT_kmod-virtio-balloon=y
CONFIG_DEFAULT_kmod-virtio-net=y
CONFIG_DEFAULT_kmod-virtio-random=y
# CONFIG_TARGET_ROOTFS_TARGZ is not set
CONFIG_TARGET_ROOTFS_EXT4FS=y
CONFIG_TARGET_EXT4_MAXINODE=6000
CONFIG_TARGET_EXT4_RESERVED_PCT=0
CONFIG_TARGET_EXT4_BLOCKSIZE_4K=y
# CONFIG_TARGET_EXT4_BLOCKSIZE_2K is not set
# CONFIG_TARGET_EXT4_BLOCKSIZE_1K is not set
CONFIG_TARGET_EXT4_BLOCKSIZE=4096
# CONFIG_TARGET_EXT4_JOURNAL is not set
CONFIG_TARGET_IMAGES_GZIP=y
CONFIG_TARGET_ROOTFS_PARTSIZE=200
CONFIG_TARGET_ROOTFS_PARTNAME="/dev/vda2"
CONFIG_TARGET_ROOTFS_INCLUDE_KERNEL=y
CONFIG_ALL=y
CONFIG_IMAGEOPT=y
CONFIG_DEVEL=y
CONFIG_NEED_TOOLCHAIN=y
CONFIG_TOOLCHAINOPTS=y
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
CONFIG_VERSION_REPO="http://gadow.freifunk.net:8004/meshkit/buildroots/x86_kvm_guest_20161121/packages"
CONFIG_PACKAGE_collectd-mod-netlink=n
CONFIG_PACKAGE_kmod-pcspkr=n
CONFIG_FASTD_ENABLE_METHOD_CIPHER_TEST=y
CONFIG_FASTD_ENABLE_METHOD_GENERIC_POLY1305=y
CONFIG_FASTD_ENABLE_METHOD_XSALSA20_POLY1305=y
CONFIG_FASTD_ENABLE_CIPHER_AES128_CTR=y
CONFIG_FASTD_ENABLE_CIPHER_SALSA20=y
CONFIG_FASTD_WITH_CMDLINE_USER=y
CONFIG_FASTD_WITH_CMDLINE_LOGGING=y
CONFIG_FASTD_WITH_CMDLINE_OPERATION=y
CONFIG_FASTD_WITH_CMDLINE_COMMANDS=y
CONFIG_FASTD_WITH_DYNAMIC_PEERS=y
CONFIG_PACKAGE_ALFRED_BATHOSTS=y


EOF

make defconfig

# allow stuff to fail from here on
set -e

echo # make everything with
echo #make $MAKEOPTS IGNORE_ERRORS=m V=99 BUILD_LOG=1
echo #please do it within screen###
echo make IGNORE_ERRORS=m V=99

#echo dont forget to set batman-adv devel version git commit number manually if you need that
