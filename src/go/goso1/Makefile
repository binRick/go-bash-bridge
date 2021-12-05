.SUFFIXES: .o .c
NAME=goso1

GCC ?= gcc
GO ?= go
GOFLAGS=-buildmode=c-shared
RM=rm -f
MV=mv -f
GREP=grep
AR=ar
RANLIB=ranlib

RELEASE_LIB_DIR=../../../RELEASE/lib
RELEASE_BIN_DIR=../../../RELEASE/bin
RELEASE_INCLUDE_DIR=../../../RELEASE/include

GO_SRC_DIR=.
SRC_FILES=*.go
SO=$(RELEASE_LIB_DIR)/$(NAME).so
HDR=$(RELEASE_INCLUDE_DIR)/$(NAME).h


all: clean init tidy build validate

build:
	color black blue
	$(GO) build -o $(SO) $(GOFLAGS) $(GO_SRC_DIR)
	color clear

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


clean:
	color red black
	$(RM) $(HDR) $(SO) go.mod
	color clear

validate_build:
	color green black
	echo KO
	color clear
	
validate:	validate_build
