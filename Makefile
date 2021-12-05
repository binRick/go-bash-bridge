MAKE ?= make

RELEASE_DIR=/root/go-bash-bridge/RELEASE
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

all: all_pre clean bash libgoso1 libcso1 call_libgoso1 call_libcso1 list validate

all_pre: 
	direnv allow .

bash:
	$(MAKE) -C $(BASH_PATH)

libgoso1:
	$(MAKE) -C $(GOSO1)

call_libgoso1:
	$(MAKE) -C $(CCALLGOSO1)

libcso1:
	$(MAKE) -C $(CSO1_PATH)

call_libcso1:
	$(MAKE) -C $(GOCALLCSO1)

clean:
	rm -rf $(RELEASE_DIR)

init:
	$(MKDIR) $(RELEASE_BIN_DIR)
	$(MKDIR) $(RELEASE_LIB_DIR)
	$(MKDIR) $(RELEASE_INCLUDE_DIR)

list:
	color green black
	find $(RELEASE_DIR) -type f
	color reset

validate:
	color blue black
	env $(EXEC_ENV) ./RELEASE/bin/call_libcso1-static
	color cyan black
	env $(EXEC_ENV) ./RELEASE/bin/call_libcso1-dynamic
	color reset
	color magenta black
	env $(EXEC_ENV) ./RELEASE/bin/call_libgoso1-static
	color yellow black
	env $(EXEC_ENV) ./RELEASE/bin/call_libgoso1-dynamic
	color reset
