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

SRC_FILES_STATIC=main_static.go
SRC_FILES_DYNAMIC=main_dynamic.go
NAME=call_libcso1
SRC=call_libcso1.c
OBJ=call_libcso1.o
LIB_SO=libcall_libcso1.so
LIB_OBJ=libcall_libcso1.o
LIB_AR=libcall_libcso1.a

STATIC_TAGS=-tags=static
DYNAMIC_TAGS=-tags=dynamic

all: clean init tidy build validate

tidy:
	color red black
	gofmt -w $(SRC_FILES_DYNAMIC) $(SRC_FILES_STATIC)
	goimports -w $(SRC_FILES_DYNAMIC) $(SRC_FILES_STATIC)
	color clear

init:
	color yellow black
	[[ -f go.mod ]] || $(GO) mod init $(NAME)
	$(GO) mod tidy
	$(GO) get
	color clear

build: build_static build_dynamic

build_dynamic:
	color black blue
	$(GO) build -o $(RELEASE_BIN_DIR)/$(NAME)-dynamic $(DYNAMIC_TAGS) $(SRC_FILES_DYNAMIC)
	color clear

build_static:
	color black blue
	$(GO) build -o $(RELEASE_BIN_DIR)/$(NAME)-static $(STATIC_TAGS) $(SRC_FILES_STATIC)
	color clear

clean:
	color red black
	$(RM) go.mod go.sum $(RELEASE_BIN_DIR)/$(NAME) $(NAME)-static $(NAME)-dynamic $(RELEASE_BIN_DIR)/$(NAME)-static $(RELEASE_BIN_DIR)/$(NAME)-dynamic
	color clear

validate_build: validate_static validate_dynamic

validate_dynamic:
	color green black
	$(RELEASE_BIN_DIR)/$(NAME)-dynamic
	color clear

validate_static:
	color green black
	$(RELEASE_BIN_DIR)/$(NAME)-static
	color clear
	
validate:	validate_build
