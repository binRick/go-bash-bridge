MAKE ?= make


RELEASE_DIR=./RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include

EXEC_ENV=LD_LIBRARY_PATH=$(RELEASE_LIB_DIR)

GOSO1=./src/go/goso1
GOCALLCSO1=./src/go/call_cso1

CSO1=./src/c/cso1
CCALLGOSO1=./src/c/call_goso1

all: clean goso1 cso1 call_goso1 call_cso1 list

goso1:
	$(MAKE) -C $(GOSO1)

call_goso1:
	$(MAKE) -C $(CCALLGOSO1)

cso1:
	$(MAKE) -C $(CSO1)

call_cso1:
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
	env $(EXEC_ENV) ./RELEASE/bin/call_cso1
	env $(EXEC_ENV) ./RELEASE/bin/call_goso1
