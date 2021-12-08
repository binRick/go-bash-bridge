#!/usr/bin/env bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)



 ~/go-bash-bridge/run << EOF
cd /
cd /root
enable -f ~/go-bash-bridge/RELEASE/lib/bash/seq seq
enable -d seq
true
EOF



exit



export PATH=$PATH:$(pwd)/bin LD_LIBRARY_PATH=$(pwd)/RELEASE/lib
START_DIR="$(pwd)"
ARGV0="${1:-}"
shift||true
ARGS="${@:-}"

source ../.envrc
TEST_BASH=/usr/bin/bash
TEST_BASH=$START_DIR/../RELEASE/bin/bash
TEST_BASH=$START_DIR/../src/dist/bash-5.1.8/bash

BASH_TEST_PREFIX="command env command $TEST_BASH --noprofile"

if [[ "$ARGV0" == shell ]]; then
	rc=$(mktemp)
	rc1=$(mktemp)
	cat <<EOF >$rc1
  #id
  enable -f ~/go-bash-bridge/RELEASE/lib/bash/id id
  enable -f ~/go-bash-bridge/RELEASE/lib/bash/cut cut
  enable -f ~/go-bash-bridge/RELEASE/lib/bash/seq seq
  enable -f ~/go-bash-bridge/RELEASE/lib/bash/dirname dirname
  id
  source ~/go-bash-bridge/scripts/oh-my-bash-bashrc.sh
EOF
	cat <<EOF >$rc
BUILTIN_MODULES="\$(find src/.libs/ -type f -name "*.so")"
echo -e "\$BUILTIN_MODULES"|while read -r m; do
  name="\$(basename \$m .so)"
  cmd="{ enable -f \$m \$name && enable -d \$name; }; enable -f \$m \$name"
  echo "\$cmd"
  eval "\$cmd" | tr '\n' ' '
  pwd
  echo OK
  cat ~/go-bash-bridge/src/dist/bash-it/themes.txt|tr '\n' ' '
  eval $ARGS
done
ansi --cyan --bg-black "\$BUILTIN_MODULES"
ansi --blue --bold "\$LOAD_CMDS"
EOF
	rc_dat="$(ansi --yellow --italic "$(cat $rc1)")"
	echo -e "Starting $TEST_BASH with rc file contents:\n$rc_dat"
	cmd="$BASH_TEST_PREFIX --rcfile $rc1 -i"
  >&2 echo -e "$cmd"
	eval "$cmd"
	unlink $rc
	unlink $rc1
	exit 0
fi
