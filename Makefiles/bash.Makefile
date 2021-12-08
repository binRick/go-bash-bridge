.DEFAULT_GOAL := all

help: build
	@color green
	@echo "Welcome to the Project!"
	@color reset

dev: ## gets you back to a clean working state
	@echo $(MAKEFILE_LIST)
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@echo OK


p: rm untar build

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
BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include


SRC_DIR=$(BASE_DIR)/src
LIB_DIR=$(BASE_DIR)/lib
DIST_DIR=$(SRC_DIR)/dist
TMP_DIR=$(BASH_DIR)/tmp
BASH_DIR=$(DIST_DIR)/bash-$(BASH_VER)
BASH_LIB_DIR=$(RELEASE_DIR)/lib/bash
BUILTINS_DIR=$(BASH_DIR)/examples/builtins

TARBALL=bash-$(BASH_VER).tar.gz
TARBALL_PATH=$(RELEASE_DIST_DIR)/bash-$(BASH_VER).tar.gz


PATCHES=$(shell ls $(BASE_DIR)/patches/*.patch)
PH=$(shell cat $(BASE_DIR)/patches/*.patch|md5sum|cut -d' ' -f1)

CONFIGURE_LOG=$(TMP_DIR)/.configured-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log
PATCHES_LOG=$(TMP_DIR)/bash-$(BASH_VER)-patches-$$(date +%Y%m%d%H).log
UNTAR_LOG=$(DIST_DIR)/.untarred-bash-$(BASH_VER)-$$(date +%Y%m%d%H).log
BUILTINS_LOG=$(BASE_DIR)/src/bash/builtins.txt
LOADABLES_LOG=$(BASE_DIR)/src/bash/loadables.txt
LOADABLES_SRC_DIR=$(BASH_DIR)/examples/loadables
_CP_COMPILED_LOADABLES_CMD = "cd $(LOADABLES_SRC_DIR)/. && command cp -v $(COMPILED_LOADABLES) $(BASH_LIB_DIR)/."


all: init fetch untar build

build: patch configure static strip copy validate lib

init: init_go
	@color black magenta
	mkdir -p $(TMP_DIR)
	mkdir -p $(BASH_LIB_DIR)
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(BIN_DIR)
	mkdir -p $(DIST_DIR)
	mkdir -p $(BASH_LIB_DIR)
	@color reset

init_go:
	command -v goimports || go install golang.org/x/tools/cmd/goimports@latest

rmrf: rm
	$(RMRF) $(DIST_DIR)/$(TARBALL)

rm:
	@color black red
	$(RMRF) $(DIST_DIR)/bash-$(BASH_VER)
	@color reset

clean: fetch untar
	@color black yellow
	@color reset

fetch: 
	[[ -f $(DIST_DIR)/$(TARBALL) ]] || wget "https://ftp.gnu.org/gnu/bash/$(TARBALL)" -O $(DIST_DIR)/$(TARBALL)

patch: init cp ## Apply C Patches to Bash Source Code
	@color black blue
	[[ -f $(PATCHES_LOG) ]] || touch $(PATCHES_LOG)
	grep $(PH) $(PATCHES_LOG)|| ( for p in $(PATCHES); do sh -c "patch -d $(DIST_DIR)/bash-$(BASH_VER) --backup -p1 -i $$p | tee $(PATCHES_LOG)-cur"; done) && cat $(PATCHES_LOG)-cur > $(PATCHES_LOG)

cp: ## Copy Includes to Bash Source Tree
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	rsync ~/go-bash-bridge/src/c/utils/icecream.h ~/go-bash-bridge/src/dist/bash-5.1.8/.
	rsync ~/go-bash-bridge/src/c/utils/color.h ~/go-bash-bridge/src/dist/bash-5.1.8/.
	rsync ~/go-bash-bridge/src/c/utils/gbb_loader.c ~/go-bash-bridge/src/dist/bash-5.1.8/.
#	rsync ~/go-bash-bridge/src/c/utils/json.h ~/go-bash-bridge/src/dist/bash-5.1.8/.
#	rsync ~/go-bash-bridge/src/c/utils/json.c ~/go-bash-bridge/src/dist/bash-5.1.8/.

untar: ## Unpack Bash Source code from Tarball
	@color black blue
	[[ -d "$($(DIST_DIR)/.untaring-bash-$(BASH_VER).log)" ]] && [[ -f "$(UNTAR_LOG)" ]] || eval tar -C $(DIST_DIR) -xf $(DIST_DIR)/$(TARBALL) -v >  $(DIST_DIR)/.untaring-bash-$(BASH_VER).log && ( date +%s && command cat $(DIST_DIR)/.untaring-bash-$(BASH_VER).log) > $(UNTAR_LOG)
	#(cd $(DIST_DIR)/bash-$(BASH_VER) && make clean 2>/dev/null||true) 2>&1 >/dev/null
	@color reset

validate:
	@color black green
	@echo -ne $(BIN_DIR)/bash:\ 
	@eval $(BIN_DIR)/bash --version|head -n1
	@eval $(BIN_DIR)/bash --norc --noprofile -c "$(TEST_CMD)"
	(eval $(BIN_DIR)/bash --norc --noprofile -c '$(ECHO_OK_CMD)'||true)|grep '^OK$$'
	@color reset

LOADABLES_CFILES=$(shell command ls $(BASH_DIR)/examples/loadables/*.c|xargs -I % basename % |sort -u)
LOADABLES=$(shell command ls $(BASH_DIR)/examples/loadables/*.c|xargs -I % basename % .c|sort -u)
COMPILED_LOADABLES=$(shell file $(BASH_DIR)/examples/loadables/*|grep 'ELF 64-bit'|cut -d':' -f1|sort -u|xargs -I % basename % .o|sort -u)
# > $(LOADABLES_LOG)


# macro to replace file suffix list:
CFILES=abc.c def.c
OFILES = $(CFILES:.c=.o)


b:
	echo $@
	echo $?
	@color reset
	@hr -s 45 -c '-'| bline -a green
	@color yellow black
	@echo CFILES=$(CFILES)
	@color blue black
	@echo OFILES=$(OFILES)
	@color black green
	@echo LOADABLES=$(LOADABLES) 
	@color black blue
	@echo LOADABLES_CFILES=$(LOADABLES_CFILES)
	@color black yellow
	@echo COMPILED_LOADABLES=$(COMPILED_LOADABLES)
	@color reset

builtins: init
	@color reset
	@color black yellow
	(command cd $(BASH_DIR)/examples/loadables/. && make)


CP_COMPILED_LOADABLES_CMD=cd $(LOADABLES_SRC_DIR)/. && command cp -v $(COMPILED_LOADABLES) $(BASH_LIB_DIR)/.

lib: builtins b
	@echo $(BASH_LIB_DIR)		
	@color black green
	@echo LOADABLES=$(LOADABLES) 
	@color black blue
	@echo LOADABLES_CFILES=$(LOADABLES_CFILES)
	@color black yellow
	@echo COMPILED_LOADABLES=$(COMPILED_LOADABLES)
	@color white black
	@echo $(_CP_COMPILED_LOADABLES_CMD)
	@color red black
	$(CP_COMPILED_LOADABLES_CMD)
	@color green black
	@echo
	@echo "##############################################"
	@find $(RELEASE_DIR) -type f | cut -d/ -f5-100
	@echo "##############################################"
	@echo
	@color reset

copy: ## Copy libbash.a and bash binary
	rsync $(BASH_DIR)/libbash.a $(BASH_LIB_DIR)/libbash.a
	rsync $(BASH_DIR)/bash $(BIN_DIR)/bash

configure: ## Configure Bash Source Tree
	@color black blue
	[[ -f "$(CONFIGURE_LOG)" ]] || (cd $(DIST_DIR)/bash-$(BASH_VER) && ./configure | tee $(CONFIGURE_LOG)-cur) 2>&1 | pv -l -s 608 -N Configure\ Bash\ v$(BASH_VER) | wc -l && cat $(CONFIGURE_LOG)-cur > $(CONFIGURE_LOG)
	@color reset

static: ## Compile Static Bash
	@color black blue
	cd $(DIST_DIR)/bash-$(BASH_VER) && make static 2>&1 | pv -l -s 491 -N Compile\ Static\ Bash\ v$(BASH_VER)
	@color reset
# | wc -l

strip: ## Compile Stripped Bash Binary
	@color black blue
	cd $(DIST_DIR)/bash-$(BASH_VER) && make -j 5 strip 2>&1 | pv -l -s 510 -N Compile\ Striped\ Binaries\ Bash\ v$(BASH_VER)
	@color reset



