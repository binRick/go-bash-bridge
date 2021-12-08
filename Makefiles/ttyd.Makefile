
NAME=ttyd
REPO=binRick/$(NAME)
BASE_DIR=/root/go-bash-bridge
DIST_DIR=$(BASE_DIR)/src/dist
BASE_REPO_DIR=$(DIST_DIR)/$(NAME)
REPO_CLONE_DIR=$(BASE_REPO_DIR)/repo
RELEASE_DIR=$(BASE_DIR)/RELEASE
RMRF=rm -rf
RMF=rm -f

all: init clone build test install

init:
	mkdir -p $(BASE_REPO_DIR)
	mkdir -p $(RELEASE_DIR)/lib
	mkdir -p $(RELEASE_DIR)/include

clone:	
	@color green
	@color ul
	[[ -d $(REPO_CLONE_DIR) ]] || git clone --recurse-submodules https://github.com/$(REPO) $(REPO_CLONE_DIR)
	cd $(REPO_CLONE_DIR) && git pull --recurse-submodules
	@color reset

clean:
	[[ -d $(BASE_REPO_DIR) ]] && rm -rf  $(BASE_REPO_DIR)
	[[ -f $(RELEASE_DIR)/bin/ttyd ]] && $(RMF) $(RELEASE_DIR)/bin/ttyd

rmrf: clean
	$(RMRF) /opt/stage

build:
	[[ -d /opt/stage/x86_64-linux-musl ]] || { cd $(REPO_CLONE_DIR) && ./scripts/cross-build.sh; }
	[[ -d $(REPO_CLONE_DIR)/build ]] || mkdir $(REPO_CLONE_DIR)/build
	cd $(REPO_CLONE_DIR)/build && cmake ../.
	cd $(REPO_CLONE_DIR)/build && make


container-build:
	cd $(REPO_CLONE_DIR) && docker build -f Dockerfile.alpine .

test:
	$(REPO_CLONE_DIR)/build/ttyd --version

install:
	rsync $(REPO_CLONE_DIR)/build/ttyd $(RELEASE_DIR)/bin/.
#	rsync $(REPO_CLONE_DIR)/src/*.c $(RELEASE_DIR)/include
#	rsync $(REPO_CLONE_DIR)/src/*.h $(RELEASE_DIR)/include


