
NAME=slog
REPO=slayers-git/$(NAME)
BASE_DIR=/root/go-bash-bridge
DIST_DIR=$(BASE_DIR)/src/dist
BASE_REPO_DIR=$(DIST_DIR)/$(NAME)
REPO_CLONE_DIR=$(BASE_REPO_DIR)/repo
RELEASE_DIR=$(BASE_DIR)/RELEASE

all: init clone build test install validate

init:
	mkdir -p $(BASE_REPO_DIR)
	mkdir -p $(RELEASE_DIR)/lib
	mkdir -p $(RELEASE_DIR)/include

clone:	
	[[ -d $(REPO_CLONE_DIR) ]] || git clone --recurse-submodules https://github.com/$(REPO) $(REPO_CLONE_DIR)
	cd $(REPO_CLONE_DIR) && git pull --recurse-submodules
	color reset

clean:
	rm -rf $(DIST_DIR)/$(NAME)/repo

build:
	cd $(REPO_CLONE_DIR)/. && cmake . && make
	gcc $(REPO_CLONE_DIR)/test/logfile.c -o $(REPO_CLONE_DIR)/test/logfile -lslog -L $(REPO_CLONE_DIR)/lib

test:
	env LD_LIBRARY_PATH=$(REPO_CLONE_DIR)/lib $(REPO_CLONE_DIR)/test/logfile

install:
	rsync $(REPO_CLONE_DIR)/*.h $(RELEASE_DIR)/include/.
	rsync $(REPO_CLONE_DIR)/lib/libslog.so $(RELEASE_DIR)/lib/.

validate:
	find RELEASE -type f|grep slog
