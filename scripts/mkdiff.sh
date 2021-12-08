#!/usr/bin/env bash
set -eou pipefail

BASE_DIR=~/go-bash-bridge
PATCHES_DIR=$BASE_DIR/patches
BASH_TARBALL=~/go-bash-bridge/src/dist/bash-5.1.8.tar.gz
BASH_DIR=~/go-bash-bridge/src/dist/bash-5.1.8
OBASH_DIR=~/go-bash-bridge/src/dist/bash-5.1.8-orig

#if [[ ! -d "$OBASH_DIR" ]]; then
#  td=$(mktemp -d)
#  cd $td
#  tar xf $BASH_TARBALL
#  mv bash-5.1.8 $OBASH_DIR
#  cd $OBASH_DIR
#  pwd
#  ls
#fi


BASH_FILES="\
 eval.c\
 execute_cmd.c\
 builtins/cd.def\
 config-top.h\
 builtins/enable.def\
 builtins/eval.def\
"
ID=0

diff_bash_file(){
  patch_file="$PATCHES_DIR/bash-$(printf "%04d" $ID)-$(echo -e $1|tr '/' '-').patch"
  cmd="cd $BASH_DIR/../. && diff -Naur \
    $(basename $BASH_DIR)/$1.orig \
    $(basename $BASH_DIR)/$1 \
      > $patch_file"
  >&2   ansi --yellow --italic "$cmd"
  cd $BASH_DIR
  [[ -f $BASH_DIR/$1.orig ]] || rsync $OBASH_DIR/$1 $BASH_DIR/$1.orig
  #eval "$cmd"
  ID=$(($ID+1))
}

while read -r f; do 
  diff_bash_file $f
done < <(echo -e "$BASH_FILES"|tr ' ' '\n'|grep -v '^$')

#> ../../../patches/010-eval-command-callback.patch
#diff -Naur builtins/cd.def.orig builtins/cd.def \

#> ../../../patches/011-builtins-cd.patch
#diff -Naur execute_cmd.c.orig execute_cmd.c \

#> ../../../patches/012-execute-cmd.c.patch

#bat ../../../patches/010-eval-command-callback.patch
#git add ../../../patches/*.patch
#git commit ../../../patches/*.patch -m 'auto commit'
#git push
