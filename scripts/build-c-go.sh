#!/usr/bin/bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source ./../.envrc
SCRIPTS_DIR="$(pwd)"
VERSION="${1:-$BUILD_BASH_VERSION}"
[ "$VERSION" == "" ] && echo "build.sh: must specify bash version to download" && exit 1
command -v patch || dnf -y install patch

C_GO_FILE_NAME=c.go
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
BASH_SOURCE_CODE_DIRECTORY="$DIST_DIR/$bashrc"
tarball="$bashsrc.tar.gz"
archive="$DIST_DIR/$tarball"
shasum="$bashsrc.sha256"

[[ -d $BIN_DIR ]] || mkdir -p $BIN_DIR
[[ -d $LIB_DIR ]] || mkdir -p $LIB_DIR
[[ -d $GBB_DIR ]] || mkdir -p $GBB_DIR

get_c_go_bytes() {
	if [[ ! -f "$C_GO_FILE" ]]; then
		echo 0
	else
		command cat $C_GO_FILE | command wc -c
	fi
	true
}

if [ ! -f "$(dirname $BASH_SOURCE_CODE_DIRECTORY)/$tarball" ]; then
	(
		cd "$(dirname $BASH_SOURCE_CODE_DIRECTORY) /.)" && wget "https://ftp.gnu.org/gnu/bash/$tarball"
	)
fi

(
	cd "${BASH_SOURCE_CODE_DIRECTORY}"

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

	#  if [[ ! -f "$C_GO_FILE" ]]; then
	cat <<EOF >$C_GO_FILE
      package bash

      // #cgo LDFLAGS: ${ldflags}
      import "C"
EOF
	gofmt -w $C_GO_FILE
	#  fi
)

# always rebuild because Go doesn't know if C files/libraries have changed
exit 0
#go install -a -v
