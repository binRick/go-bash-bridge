#!/usr/bin/env bash
set -e
cd $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
cd ~/go-bash-bridge
export PATH=$PATH:$(pwd)/bin LD_LIBRARY_PATH=$(pwd)/RELEASE/lib
BASE_DIR="$(pwd)"
RELEASE_DIR=$BASE_DIR/RELEASE
ARGV0="${1:-shell}"
shift||true
ARGS="${@:-}"

#source ../.envrc
TEST_BASH=/usr/bin/bash
TEST_BASH=$BASE_DIR/src/dist/bash-5.1.8/bash
TEST_BASH=$BASE_DIR/RELEASE/bin/bash

BASH_TEST_PREFIX="$(command -v env) $(command -v $TEST_BASH) --noprofile"

get_bash_rc_contents(){
	cat <<EOF
  #id
  for m in id cut seq dirname; do
    enable -f $RELEASE_DIR/lib/bash/$m
  done
  id
  [[ -f $BASE_DIR/scripts/oh-my-bash-bashrc.sh ]] && source $BASE_DIR/scripts/oh-my-bash-bashrc.sh
EOF
}

if [[ "$ARGV0" == shell ]]; then
	cmd="$BASH_TEST_PREFIX --rcfile <(get_bash_rc_contents) -i"
  exec 2>&1
	eval "exec $cmd"
	exit 100
fi
