.SUFFIXES: .o .c

GCC ?= gcc
GO ?= go
GOFLAGS=build -buildmode=c-archive
SHARED_OBJ_FLAGS=-shared -lm
CFLAGS=
LIBS=

RM=rm -f
MV=mv -f
CP=cp -f
GREP=grep
AR=ar
RANLIB=ranlib

RELEASE_DIR=/root/go-bash-bridge/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include
LIBGOSO1=libgoso1.so
LIBGOSO1_PATH=$(RELEASE_LIB_DIR)/$(LIBGOSO1)

NAME=call_libgoso1
BIN_STATIC=$(NAME)-static
BIN_DYNAMIC=$(NAME)-dynamic
SRC_FILE=main.c
SRC_FILE_DL=main_dl.c

all: init clean build release validate

build: dynamic static

dynamic:
	color magenta black
	$(GCC) -o $(BIN_DYNAMIC) -L $(RELEASE_LIB_DIR) $(SRC_FILE_DL) $(LIBGOSO1_PATH) -ldl
	color reset

static:
	color blue black
	$(GCC) -o $(BIN_STATIC) -L $(RELEASE_LIB_DIR) -I $(RELEASE_INCLUDE_DIR) -lgoso1 $(SRC_FILE_DL)
	color reset

release:
	color green black
	$(MV) $(BIN_STATIC) $(RELEASE_BIN_DIR)/$(BIN_STATIC)
	$(MV) $(BIN_DYNAMIC) $(RELEASE_BIN_DIR)/$(BIN_DYNAMIC)
	color reset

init:
	color black magenta
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(RELEASE_BIN_DIR)
	color reset

clean:
	color black yellow
	$(RM) $(BIN_STATIC) $(BIN_DYNAMIC) $(RELEASE_BIN_DIR)/$(BIN_DYNAMIC) $(RELEASE_BIN_DIR)/$(BIN_STATIC)
	color reset

validate:
	color black blue
	$(RELEASE_BIN_DIR)/$(BIN_STATIC)
	$(RELEASE_BIN_DIR)/$(BIN_DYNAMIC)
	color reset
