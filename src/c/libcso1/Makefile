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

RELEASE_LIB_DIR=../../../RELEASE/lib
RELEASE_BIN_DIR=../../../RELEASE/bin
RELEASE_INCLUDE_DIR=../../../RELEASE/include

NAME=libcso1
HDR=$(NAME).h
SRC=$(NAME).c
OBJ=$(NAME).o
SO=$(NAME).so

all: init clean dynamic static include validate

include:
	$(CP) $(HDR) $(RELEASE_INCLUDE_DIR)

init:
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	mkdir -p $(RELEASE_BIN_DIR)

dynamic:
	$(GCC) -fPIC -c $(SRC)
	$(GCC) $(SHARED_OBJ_FLAGS) -o $(SO) $(OBJ)
	$(MV) $(SO) $(RELEASE_LIB_DIR)/.
	$(RM) $(OBJ)

validate_dynamic:
	color black magenta
	file $(RELEASE_LIB_DIR)/$(SO) | grep 'shared object'
	color reset

static:
	$(GCC) -c $(SRC)
	$(AR) rc $(AR) $(OBJ)
	$(RANLIB) $(AR)
	$(MV) $(AR) $(RELEASE_LIB_DIR)/.
	$(RM) $(OBJ)

validate_static:
	color black blue
	file $(RELEASE_LIB_DIR)/$(AR) | grep 'ar archive'
	color reset

clean:
	$(RM) $(RELEASE_INCLUDE_DIR)/$(HDR) $(RELEASE_LIB_DIR)/$(OBJ) $(RELEASE_LIB_DIR)/$(SO) $(RELEASE_LIB_DIR)/$(OBJ) $(RELEASE_LIB_DIR)/$(AR)

validate:	validate_dynamic validate_static
