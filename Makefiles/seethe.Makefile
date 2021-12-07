
NAME=seethe
REPO=jnguyen1098/$(NAME)
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
	rm -rf $(DIST_DIR)/$(NAME)/repo

build:
	gcc $(REPO_CLONE_DIR)/example.c -o $(REPO_CLONE_DIR)/example

test:
	$(REPO_CLONE_DIR)/example

install:
	rsync $(REPO_CLONE_DIR)/*.h $(RELEASE_DIR)/include
