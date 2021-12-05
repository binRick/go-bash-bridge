.SUFFIXES: .o .c

GCC ?= gcc
GO ?= go
GOFLAGS=build -buildmode=c-archive
CFLAGS=
LIBS=

RM=rm -f
MV=mv -f
GREP=grep
AR=ar
RANLIB=ranlib

RELEASE_LIB_DIR=../../../RELEASE/lib

NAME=example1
SRC=example1.c
OBJ=example1.o
LIB_SO=libexample1.so
LIB_OBJ=libexample1.o
LIB_AR=libexample1.a


all: clean dynamic static validate

dynamic:
	$(GCC) -fPIC -c $(SRC)
	$(GCC) -shared -o $(LIB_SO) $(OBJ)
	$(MV) $(LIB_SO) $(RELEASE_LIB_DIR)/.
	$(RM) $(LIB_OBJ)

static:
	$(GCC) -c $(SRC)
	$(AR) rc $(LIB_AR) $(OBJ)
	$(RANLIB) $(LIB_AR)
	$(MV) $(LIB_AR) $(RELEASE_LIB_DIR)/.
	$(RM) $(OBJ)

clean:
	$(RM) $(OBJ) $(LIB_SO) $(LIB_OBJ) $(LIB_AR)

validate:
	file $(RELEASE_LIB_DIR)/$(LIB_SO) | grep 'shared object'
	file $(RELEASE_LIB_DIR)/$(LIB_AR) | grep 'ar archive'
