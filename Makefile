MAKE ?= make
MKDIR=mkdir -p
BASE_DIR=/root/go-bash-bridge
RELEASE_DIR=$(BASE_DIR)/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include
EXEC_ENV=LD_LIBRARY_PATH=$(RELEASE_LIB_DIR)
GOSO1=./src/go/libgoso1
GOCALLCSO1=./src/go/call_libcso1
CSO1=libcso1
CSO1_PATH=./src/c/$(CSO1)
CCALLGOSO1=./src/c/call_libgoso1
BASH_PATH=./src/bash

all: all_pre clean makefiles bash libgoso1 libcso1 call_libgoso1 call_libcso1 list validate addons py

all_pre: 
	direnv allow .

bash: makefiles
	$(MAKE) -C $(BASH_PATH)

libgoso1:
	$(MAKE) -C $(GOSO1)

call_libgoso1:
	$(MAKE) -C $(CCALLGOSO1)

libcso1:
	$(MAKE) -C $(CSO1_PATH)

call_libcso1:
	$(MAKE) -C $(GOCALLCSO1)

include Makefiles/main-clean.Makefile

init:
	$(MKDIR) $(RELEASE_BIN_DIR)
	$(MKDIR) $(RELEASE_LIB_DIR)
	$(MKDIR) $(RELEASE_INCLUDE_DIR)

list:
	color green black
	find $(RELEASE_DIR) -type f
	color reset

include Makefiles/main-validate.Makefile

py:
	./src/py/call_libso/py2.sh
	./src/py/call_libso/py3.sh

makefiles: init makes srcs ## Execute all Makefiles

bash-it: 
	make -f Makefiles/bash-it.Makefile 2>&1 | pv -l -N bash-it  >/dev/null

makes: bash-it ## Execute Dist Makefiles
	color yellow
	make -f Makefiles/chan.Makefile 2>&1 | pv -l -N chan >/dev/null
	make -f Makefiles/c_scriptexec.Makefile 2>&1 | pv -l -N c_scriptexec >/dev/null
	make -f Makefiles/oh-my-bash.Makefile 2>&1 | pv -l -N oh-my-bash >/dev/null
	make -f Makefiles/seethe.Makefile 2>&1 | pv -l -N seethe >/dev/null
	color reset

srcs_clean:
	make -C src/c/bash_cmd_handler -w -f Makefile clean

srcs: ## Execute Custom App Makefiles
	make -C src/c/bash_cmd_handler -w -f Makefile all
