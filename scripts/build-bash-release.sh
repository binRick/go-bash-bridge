#!/usr/bin/bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ./../.envrc
SCRIPTS_DIR="$(pwd)"
VERSION="${1:-$BUILD_BASH_VERSION}"
[ "$VERSION" == "" ] && echo "build.sh: must specify bash version to download" && exit 1
command -v patch || dnf -y install patch

C_GO_FILE_NAME=c.go
PACKAGE_NAME=gbb
BASE_DIR="$(cd $SCRIPTS_DIR/../. && pwd)"
BIN_DIR=$RELEASE_DIR/bin
LIB_DIR=$RELEASE_DIR/lib
GBB_DIR="$BASE_DIR/src/go/gbb"
C_GO_FILE=$GBB_DIR/$C_GO_FILE_NAME
RELEASE_DIR=$BASE_DIR/RELEASE
BIN_DIR=$BASE_DIR/bin
LIB_DIR=$BASE_DIR/lib
DIST_DIR=$BASE_DIR/src/dist
PATCHES_DIR=$BASE_DIR/patches
bashsrc="bash-${VERSION}"
tarball="$bashsrc.tar.gz"
archive="$DIST_DIR/$tarball"
shasum="$tarball.sha256"
shasumfile="$DIST_DIR/$shasum"
export BASH_SOURCE_CODE_DIRECTORY=$DIST_DIR/$bashsrc

[[ -d $BIN_DIR ]] || mkdir -p $BIN_DIR
[[ -d $LIB_DIR ]] || mkdir -p $LIB_DIR
[[ -d $GBB_DIR ]] || mkdir -p $GBB_DIR

check_c_go_file() {
	CGF1="$(command cat $C_GO_FILE)"
	ansi --blue --bold "$CGF1"
	sleep 5
}

get_c_go_bytes() {
	if [[ ! -f "$C_GO_FILE" ]]; then
		echo 0
	else
		command cat $C_GO_FILE | command wc -c
	fi
	true
}

get_ldflags() {
	(
		cd "$BASH_SOURCE_CODE_DIRECTORY"
		ldflags="$(make ldflags | tail -1 | sed -E "s%\./%\${SRCDIR}/${bashsrc}/%g")"
		ldflags="$(
			for ldflag in $ldflags; do
				[ "${ldflag:0:1}" == "-" ] && echo -n "$ldflag " || echo -n "\${SRCDIR}/${bashsrc}/${ldflag} "
			done
		)"
	)
	true
}

download_bash_source() {

	(
		if [[ ! -f "$archive" ]]; then
			(
				cd $(dirname $archive) && wget "https://ftp.gnu.org/gnu/bash/$tarball"
			)
		fi
		true
	)

}







download_bash_source






(cd $DIST_DIR && shasum -c "$shasumfile") || exit 1
if [ ! -d "$BASH_SOURCE_CODE_DIRECTORY" ]; then
	(
    cd $$BASH_SOURCE_CODE_DIRECTORY
		tar zxf "$archive"
		cd "${BASH_SOURCE_CODE_DIRECTORY}"
		for p in $PATCHES_DIR/*.patch; do
			patch -p1 <"$p"
		done
	)
fi

(
	cd "${BASH_SOURCE_CODE_DIRECTORY}"
	do_configure() {
		cd $BASH_SOURCE_CODE_DIRECTORY/. && ./configure
	}
	make static || { do_configure && make -j 5 static; }
	make strip || { do_configure && make -j 5 strip; }

	rsync ./libbash.a $LIB_DIR/libbash.a
	rsync ./bash $BIN_DIR/bash

	for ldflag in $ldflags; do
		[ "${ldflag:0:1}" == "-" ] && echo -n "$ldflag " || echo -n "\${bashsrc}/${ldflag} "
	done < <(make ldflags | tail -n1 | sed -E "s%\./%\${SRCDIR}/${bashsrc}/%g") >$C_GO_FILE

)

(
	cd "$BASH_SOURCE_CODE_DIRECTORY"

	ldflags="$(make ldflags | tail -1 | sed -E "s%\./%\${SRCDIR}/${bashsrc}/%g")"
	echo
	echo
	ansi --magenta --bold "$(echo -e "$ldflags")"
	echo
	echo

	ldflags="$(
		for ldflag in $ldflags; do
			[ "${ldflag:0:1}" == "-" ] && echo -n "$ldflag " || echo -n "\${SRCDIR}/${bashsrc}/${ldflag} "
		done
	)"
	echo
	echo
	ansi --blue --bold "$(echo -e "$ldflags")"
	echo
	echo

	cat <<EOF >$C_GO_FILE
      package $PACKAGE_NAME

      // #cgo LDFLAGS: ${ldflags}
      import "C"
EOF

	gofmt -w $C_GO_FILE

)

# always rebuild because Go doesn't know if C files/libraries have changed
check_c_go_file
exit 0
#go install -a -v
