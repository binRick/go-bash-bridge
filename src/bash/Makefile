GCC ?= gcc
GO ?= go
CFLAGS=
LIBS=

RM=rm -f
RMRF=rm -rf
MV=mv -f
CP=cp -f
GREP=grep
AR=ar
RANLIB=ranlib

PASSH_ALREADY_EXISTS_PATCH_WRAPPER=passh -p n -P already\ exists
PASSH_APPLY_PATCH_WRAPPER=passh -p n -P Apply\ anyway
PASSH_WRAPPER=$(PASSH_APPLY_PATCH_WRAPPER) $(PASSH_ALREADY_EXISTS_PATCH_WRAPPER) 
TEST_CMD=date
ECHO_OK_CMD=echo\ OK
BASE_DIR=/root/go-bash-bridge
RELEASE_DIR=/root/go-bash-bridge/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include

BASH_VER=5.1.8
SRC_DIR=$(BASE_DIR)/src
DIST_DIR=$(SRC_DIR)/dist
BASH_DIR=$(DIST_DIR)/bash-$(BASH_VER)

TARBALL=bash-$(BASH_VER).tar.gz
TARBALL_PATH=$(RELEASE_DIST_DIR)/bash-$(BASH_VER).tar.gz
PATCHES=$(shell ls $(BASE_DIR)/patches/*.patch)

all: init fetch untar build

init:
	color black magenta
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(RELEASE_BIN_DIR)
	mkdir -p $(DIST_DIR)
	color reset

rm:
	color black red
	#$(RMRF) $(DIST_DIR)/$(TARBALL)
	$(RMRF) $(DIST_DIR)/bash-$(BASH_VER)
	color reset

clean: fetch untar
	color black yellow
	color reset

patch:
	color black blue
	for p in $(PATCHES); do sh -c "$(PASSH_WRAPPER) patch -d $(DIST_DIR)/bash-$(BASH_VER) --backup -p1 -i $$p"; done
	color reset

build: patch configure static strip

configure:
	color black blue
	(cd $(DIST_DIR)/bash-$(BASH_VER) && ./configure) 2>&1 | pv -l -s 608 -N Configure\ Bash\ v$(BASH_VER) | wc -l
	color reset

static:
	color black blue
	(cd $(DIST_DIR)/bash-$(BASH_VER) && make static) 2>&1 | pv -l -s 491 -N Compile\ Static\ Bash\ v$(BASH_VER) | wc -l
	color reset

strip:
	color black blue
	(cd $(DIST_DIR)/bash-$(BASH_VER) && make -j 5 strip) 2>&1 | pv -l -s 510 -N Compile\ Striped\ Binaries\ Bash\ v$(BASH_VER) | wc -l
	color reset

fetch:
	color black blue
	[[ -f $(DIST_DIR)/$(TARBALL) ]] || wget "https://ftp.gnu.org/gnu/bash/$(TARBALL)" -O $(DIST_DIR)/$(TARBALL)
	color reset

untar:
	color black blue
	tar -C $(DIST_DIR) -xf $(DIST_DIR)/$(TARBALL)
	(cd $(DIST_DIR)/bash-$(BASH_VER) && make clean||true) 2>&1 >/dev/null
	color reset

validate:
	color black green
	echo -ne $(BASH_DIR)/bash:\ 
	eval $(BASH_DIR)/bash --version|head -n1
	eval $(BASH_DIR)/bash --norc --noprofile -c "$(TEST_CMD)"
	(eval $(BASH_DIR)/bash --norc --noprofile -c '$(ECHO_OK_CMD)'||true)|grep '^OK$$'
	color reset
