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

RELEASE_DIR=../../../RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include
GOSO1=$(RELEASE_LIB_DIR)/goso1.so

NAME=call_goso1
BIN=$(NAME)
SRC_FILE=main.c
SRC_FILE_DL=main_dl.c

all: init clean build release validate

build:
	color blue black
	#$(GCC) -o $(BIN) -L $(RELEASE_LIB_DIR) -I  $(RELEASE_INCLUDE_DIR) -ldl $(SRC_FILE_DL)
	$(GCC) -o $(BIN) -L $(RELEASE_LIB_DIR) -ldl $(SRC_FILE_DL) goso1.so
#	$(GCC) -o $(BIN) -I $(RELEASE_INCLUDE_DIR) $(SRC_FILE) -ldl $(GOSO1)
# $(GOSO1)
	color reset

release:
	color green black
	$(MV) $(BIN) $(RELEASE_BIN_DIR)/$(BIN)
	color reset

init:
	color black magenta
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(RELEASE_BIN_DIR)
	color reset

clean:
	color black yellow
	$(RM) $(BIN) $(RELEASE_BIN_DIR)/$(BIN)
	color reset

validate:
	color black blue
	$(RELEASE_BIN_DIR)/$(BIN)
	color reset
