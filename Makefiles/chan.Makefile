
NAME=chan
REPO=tylertreat/$(NAME)
BASE_DIR=/root/go-bash-bridge
DIST_DIR=$(BASE_DIR)/src/dist
BASE_REPO_DIR=$(DIST_DIR)/$(NAME)
REPO_CLONE_DIR=$(BASE_REPO_DIR)/repo
RELEASE_DIR=$(BASE_DIR)/RELEASE

all: init clone build test install

init:
	mkdir -p $(BASE_REPO_DIR)
	mkdir -p $(RELEASE_DIR)/lib
	mkdir -p $(RELEASE_DIR)/include

clone:	
	[[ -d $(REPO_CLONE_DIR) ]] || git clone --recurse-submodules https://github.com/$(REPO) $(REPO_CLONE_DIR)
	cd $(REPO_CLONE_DIR) && git pull --recurse-submodules
	color reset

clean:
	rm -rf /root/go-bash-bridge/src/dist/$(NAME)/repo
	rm -rf /root/go-bash-bridge/src/dist/$(NAME)

build:
	[[ -f $(REPO_CLONE_DIR)/configure ]] || { cd $(REPO_CLONE_DIR) && ./autogen.sh; }
	[[ -f $(REPO_CLONE_DIR)/Makefile ]] || { cd $(REPO_CLONE_DIR) && ./configure; }
	cd $(REPO_CLONE_DIR) && make

test:
	$(REPO_CLONE_DIR)/examples/buffered
	$(REPO_CLONE_DIR)/examples/unbuffered
	$(REPO_CLONE_DIR)/examples/close
	$(REPO_CLONE_DIR)/examples/select

install:
	rsync $(REPO_CLONE_DIR)/.libs/*.a $(RELEASE_DIR)/lib


