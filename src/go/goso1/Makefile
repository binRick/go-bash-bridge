.SUFFIXES: .o .c
NAME=goso1

GCC ?= gcc
GO ?= go
GOFLAGS=-buildmode=c-shared 
RM=rm -f
RMRF=rm -rf
MV=mv -f
GREP=grep
AR=ar
RANLIB=ranlib

RELEASE_DIR=../../../RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include

GO_SRC_DIR=.
SRC_FILES=*.go
SO=$(NAME).so
SOF=$(RELEASE_LIB_DIR)/$(SO)
HDR=$(NAME).h
HDRF=$(RELEASE_INCLUDE_DIR)/$(HDR)


all: clean init tidy cgo build validate release

build:
	color black blue
	$(GO) build -o $(SO) $(GOFLAGS) $(GO_SRC_DIR)
	color clear

cgo:
	$(GO) tool cgo $(SRC_FILES)

release:
	$(MV) $(HDR) $(HDRF)
	$(MV) $(SO) $(SOF)

tidy:
	color red black
	gofmt -w $(SRC_FILES)
	goimports -w $(SRC_FILES)
	color clear

init:
	mkdir -p $(RELEASE_INCLUDE_DIR)
	mkdir -p $(RELEASE_LIB_DIR)
	color yellow black
	[[ -f go.mod ]] || $(GO) mod init $(NAME)
	$(GO) mod tidy
	$(GO) get
	color clear


clean:
	color red black
	$(RM) $(HDR) $(SO) $(HDRF) $(SOF) go.mod 
	$(RMRF) _obj
	color clear

validate_build:
	color green black
	echo KO
	color clear
	
validate:	validate_build
