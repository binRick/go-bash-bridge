.SUFFIXES: .o .c .so .a

GCC ?= gcc
GO ?= go
RM=rm -f
MV=mv -f
CP=cp -f
GREP=grep
RANLIB=ranlib
AR=ar

SHARED_OBJ_FLAGS=-shared -lm

RELEASE_LIB_DIR=../../../RELEASE/lib
RELEASE_BIN_DIR=../../../RELEASE/bin
RELEASE_INCLUDE_DIR=../../../RELEASE/include

NAME=libcso1
HDR=$(NAME).h
SRC=$(NAME).c
OBJ=$(NAME).o
SO=$(NAME).so
ARF=$(NAME).a

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

static:
	$(GCC) -c $(SRC)
	$(AR) rc $(ARF) $(OBJ)
	$(RANLIB) $(ARF)
	$(MV) $(ARF) $(RELEASE_LIB_DIR)/.
	$(RM) $(OBJ)

validate_dynamic:
	color black magenta
	file $(RELEASE_LIB_DIR)/$(SO) | grep 'shared object'
	color reset

validate_static:
	color black blue
	file $(RELEASE_LIB_DIR)/$(ARF) | grep 'ar archive'
	color reset

clean:
	$(RM) $(RELEASE_INCLUDE_DIR)/$(HDR) $(RELEASE_LIB_DIR)/$(OBJ) $(RELEASE_LIB_DIR)/$(SO) $(RELEASE_LIB_DIR)/$(OBJ) $(RELEASE_LIB_DIR)/$(ARF)

validate:	validate_dynamic validate_static
