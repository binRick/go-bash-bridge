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
GO_SRC=main.go
SRC_FILES=main.go
NAME=example1
SRC=example1.c
OBJ=example1.o
LIB_SO=libexample1.so
LIB_OBJ=libexample1.o
LIB_AR=libexample1.a


all: clean init tidy build validate

tidy:
	color red black
	gofmt -w $(SRC_FILES)
	goimports -w $(SRC_FILES)
	color clear

init:
	color yellow black
	[[ -f go.mod ]] || $(GO) mod init $(NAME)
	$(GO) mod tidy
	$(GO) get
	color clear

build:
	color black blue
	$(GO) build -o $(RELEASE_BIN_DIR)/$(NAME) $(GO_SRC_DIR)
	color clear

clean:
	color red black
	$(RM) go.mod go.sum $(RELEASE_BIN_DIR)/$(NAME)
	color clear

validate_build:
	color green black
	$(RELEASE_BIN_DIR)/$(NAME)
	color clear
	
validate:	validate_build
