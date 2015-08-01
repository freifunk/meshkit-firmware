#!/bin/sh

e() {
	echo "\033[32m### $1 ###\033[0m"
}

err() {
	echo "\033[31m!!! $1 !!!\033[0m"
}

apply_patches() {
	PATCHTARGET="$1" # either openwrt or feeds
	PATCHDIR="$2"


	if [ -z "$PATCHDIR" ] || [ -z "$PATCHTARGET" ]; then
		err "Missing variables, not patching anything. Check your script."
		return
	fi

	if [ -d "$PATCHDIR" ] && [ ! -e "patched-${PATCHTARGET}" ]; then
		e "Apply patches from $PATCHDIR to $PATCHTARGET"
	        for i in `ls $PATCHDIR`;do
        	        patch -p0 --dry-run < $PATCHDIR"/$i"
			ret=$?
			if [ $ret -ne 0 ]; then
				return 1
			fi
	        done
		# dry run succeeded, do patching now
	        for i in `ls $PATCHDIR`;do
        	        patch -p0 < $PATCHDIR"/$i"
			ret=$?
			if [ $ret -ne 0 ]; then
				return 1
			fi
	        done
	        touch patched-${PATCHTARGET}
	fi
}


get_release() {
	SVNURL="$(svn info |grep ^URL | cut -d ' ' -f 2)"
	if [ -n "$SVNURL" ]; then
	        if [ -n "`echo $SVNURL |grep trunk`" ]; then
	                RELEASE="trunk"
	        else
	                RELEASE=$(echo $SVNURL | sed 's/svn:\/\/svn.openwrt.org\/openwrt\/branches\///g')
	        fi
	fi
	if [ -z "$SVNURL" ] || [ -z "$RELEASE" ]; then
	        echo "Unable to find out which release we are using."
	fi
}

get_target() {
	TARGET=$(grep "^CONFIG_TARGET_[0-9A-Za-z]*=y" .config |cut -d "=" -f 1 |cut -d "_" -f 3)
}

get_revision() {
	REV=$(svn info -r COMMITTED | awk '/^Revision:/ { print $2 }')
}

get_subtarget() {
	SUBTARGET="$(sed -ne 's/^CONFIG_TARGET_[a-z0-9.-]*_\([a-zA-Z0-9]*\)_.*=y/\1/p' .config)"
	SUBTARGET="$(echo $SUBTARGET | cut -d " " -f 1)"
	[ "$SUBTARGET" = "kvm" ] && SUBTARGET="kvm_guest"
}

update_openwrt_release() {
	get_release
	get_revision
	# version configuration
	conf_set CONFIG_VERSION_NUMBER "${RELEASE}-r${REV}"
	conf_set CONFIG_VERSION_DIST "${VERSION_DIST}"
	conf_set CONFIG_VERSION_NICK "${VERSION_NICK}"
	conf_set CONFIG_VERSION_REPO "${REPO_BASEURL}/%S/%C/packages/"
}


gen_repositories_conf() {
	echo "src imagebuilder file:packages" > target/imagebuilder/files/repositories.conf
}

feeds_update() {
	# checkout feeds and install them
	./scripts/feeds update
	./scripts/feeds install -d m -a
}

# set options in config file
conf_set() {
	OPTION="$1"
	VALUE="$2"
	if [ ! "$VALUE" = "y" ]; then
		VALUE=\"$VALUE\"
	fi
	sed -i -e "s#\# $OPTION is not set#$OPTION=$VALUE#" .config
	sed -i -e "s#$OPTION=.*#$OPTION=$VALUE#" .config
}
