.SUFFIXES: .o .c

GCC ?= gcc
GO ?= go
GOFLAGS=build -buildmode=c-archive
SHARED_OBJ_FLAGS=-shared -lm
CFLAGS=
LIBS=

RM=rm -f
MV=mv -f
GREP=grep
AR=ar
RANLIB=ranlib

RELEASE_LIB_DIR=../../../RELEASE/lib
RELEASE_BIN_DIR=../../../RELEASE/bin
RELEASE_INCLUDE_DIR=../../../RELEASE/include

GO_SRC_DIR=.
GO_SRC=example1.go
SRC_FILES=example1.go
NAME=example1
SRC=example1.c
OBJ=example1.o
LIB_SO=libexample1.so
LIB_OBJ=libexample1.o
LIB_AR=libexample1.a


all: clean tidy build

tidy:
	gofmt -w $(SRC_FILES)
	goimports -w $(SRC_FILES)

build:
	$(GO) mod init $(NAME)
	$(GO) mod tidy
	$(GO) get
	$(GO) build -o $(RELEASE_BIN_DIR)/$(NAME) $(GO_SRC_DIR)


dynamic:
	$(GCC) -fPIC -c $(SRC)
	$(GCC) $(SHARED_OBJ_FLAGS) -o $(LIB_SO) $(OBJ)
	$(MV) $(LIB_SO) $(RELEASE_LIB_DIR)/.
	$(RM) $(LIB_OBJ)

validate_dynamic:
	color black magenta
	file $(RELEASE_LIB_DIR)/$(LIB_SO) | grep 'shared object'
	color reset

static:
	$(GCC) -c $(SRC)
	$(AR) rc $(LIB_AR) $(OBJ)
	$(RANLIB) $(LIB_AR)
	$(MV) $(LIB_AR) $(RELEASE_LIB_DIR)/.
	$(RM) $(OBJ)

validate_static:
	color black blue
	file $(RELEASE_LIB_DIR)/$(LIB_AR) | grep 'ar archive'
	color reset

clean:
	$(RM) go.mod go.sum
#$(OBJ) $(LIB_SO) $(LIB_OBJ) $(LIB_AR)

validate:	validate_dynamic validate_static
