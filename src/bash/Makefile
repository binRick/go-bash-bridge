BASH_VER=5.1.8


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
TEST_CMD=$(shell command -v date)
ECHO_OK_CMD=echo\ OK
BASE_DIR=/root/go-bash-bridge
RELEASE_DIR=$(BASE_DIR)/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include


SRC_DIR=$(BASE_DIR)/src
LIB_DIR=$(BASE_DIR)/lib
DIST_DIR=$(SRC_DIR)/dist
TMP_DIR=$(BASH_DIR)/tmp
BASH_DIR=$(DIST_DIR)/bash-$(BASH_VER)

TARBALL=bash-$(BASH_VER).tar.gz
TARBALL_PATH=$(RELEASE_DIST_DIR)/bash-$(BASH_VER).tar.gz


PATCHES=$(shell ls $(BASE_DIR)/patches/*.patch)
PH=$(shell cat $(BASE_DIR)/patches/*.patch|md5sum|cut -d' ' -f1)

CONFIGURE_LOG=$(TMP_DIR)/.configured-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log
PATCHES_LOG=$(TMP_DIR)/bash-$(BASH_VER)-patches-$$(date +%Y%m%d%H).log
UNTAR_LOG=$(DIST_DIR)/.untarred-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log


all: init fetch untar build

build: patch configure static strip copy validate

init: init_go
	color black magenta
	mkdir -p $(TMP_DIR)
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(RELEASE_BIN_DIR)
	mkdir -p $(DIST_DIR)
	color reset

init_go:
	command -v goimports || go install golang.org/x/tools/cmd/goimports@latest

rmrf: rm
	$(RMRF) $(DIST_DIR)/$(TARBALL)

rm:
	color black red
	$(RMRF) $(DIST_DIR)/bash-$(BASH_VER)
	color reset

clean: fetch untar
	color black yellow
	color reset

fetch: 
	[[ -f $(DIST_DIR)/$(TARBALL) ]] || wget "https://ftp.gnu.org/gnu/bash/$(TARBALL)" -O $(DIST_DIR)/$(TARBALL)

patch:
	color black blue
	grep $(PH) $(PATCHES_LOG)|| ( for p in $(PATCHES); do sh -c "patch -d $(DIST_DIR)/bash-$(BASH_VER) --backup -p1 -i $$p | tee $(PATCHES_LOG)-cur"; done) && cat $(PATCHES_LOG)-cur > $(PATCHES_LOG)

untar:
	color black blue
	[[ -d "$($(DIST_DIR)/.untaring-bash-$(BASH_VER).log)" ]] && [[ -f "$(UNTAR_LOG)" ]] || eval tar -C $(DIST_DIR) -xf $(DIST_DIR)/$(TARBALL) -v >  $(DIST_DIR)/.untaring-bash-$(BASH_VER).log && ( date +%s && command cat $(DIST_DIR)/.untaring-bash-$(BASH_VER).log) > $(UNTAR_LOG)
	#(cd $(DIST_DIR)/bash-$(BASH_VER) && make clean 2>/dev/null||true) 2>&1 >/dev/null
	color reset

validate:
	color black green
	echo -ne $(BIN_DIR)/bash:\ 
	eval $(BIN_DIR)/bash --version|head -n1
	eval $(BIN_DIR)/bash --norc --noprofile -c "$(TEST_CMD)"
	(eval $(BIN_DIR)/bash --norc --noprofile -c '$(ECHO_OK_CMD)'||true)|grep '^OK$$'
	color reset

copy:
	rsync $(BASH_DIR)/libbash.a $(LIB_DIR)/libbash.a
	rsync $(BASH_DIR)/bash $(BIN_DIR)/bash

configure:
	color black blue
	[[ -f "$(CONFIGURE_LOG)" ]] || (cd $(DIST_DIR)/bash-$(BASH_VER) && ./configure | tee $(CONFIGURE_LOG)-cur) 2>&1 | pv -l -s 608 -N Configure\ Bash\ v$(BASH_VER) | wc -l && cat $(CONFIGURE_LOG)-cur > $(CONFIGURE_LOG)
	color reset

static:
	color black blue
	(cd $(DIST_DIR)/bash-$(BASH_VER) && make static) 2>&1 | pv -l -s 491 -N Compile\ Static\ Bash\ v$(BASH_VER) | wc -l
	color reset

strip:
	color black blue
	(cd $(DIST_DIR)/bash-$(BASH_VER) && make -j 5 strip) 2>&1 | pv -l -s 510 -N Compile\ Striped\ Binaries\ Bash\ v$(BASH_VER) | wc -l
	color reset
