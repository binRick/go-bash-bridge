#!/usr/bin/env bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export PATH=$PATH:$(pwd)/bin
START_DIR="$(pwd)"

source ../.envrc
TEST_BASH=/usr/bin/bash
TEST_BASH=$START_DIR/../RELEASE/bin/bash

BASH_TEST_PREFIX="command env command $TEST_BASH --noprofile"

if [[ "$1" == shell ]]; then
	rc=$(mktemp)
	cat <<EOF >$rc
BUILTIN_MODULES="\$(find src/.libs/ -type f -name "*.so")"
echo -e "\$BUILTIN_MODULES"|while read -r m; do
  name="\$(basename \$m .so)"
  cmd="{ enable -f \$m \$name && enable -d \$name; }; enable -f \$m \$name"
  echo "\$cmd"
  eval "\$cmd" | tr '\n' ' '
  pwd
  echo OK
  cat ../src/dist/bash-it/themes.txt|tr '\n' ' '
done
ansi --cyan --bg-black "\$BUILTIN_MODULES"
ansi --blue --bold "\$LOAD_CMDS"
EOF
	rc_dat="$(ansi --yellow --italic "$(cat $rc)")"
	echo -e "Starting $TEST_BASH with rc file contents:\n$rc_dat"
	cmd="$BASH_TEST_PREFIX --rcfile $rc -i"
	eval "$cmd"
	unlink $rc
	exit 0
fi
