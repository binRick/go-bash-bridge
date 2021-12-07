
NAME=c_scriptexec
REPO=sagiegurari/$(NAME)
BASE_DIR=/root/go-bash-bridge
DIST_DIR=$(BASE_DIR)/src/dist
BASE_REPO_DIR=$(DIST_DIR)/c_scriptexec
REPO_CLONE_DIR=$(BASE_REPO_DIR)/repo
RELEASE_DIR=$(BASE_DIR)/RELEASE

all: init clone build install

init:
	mkdir -p $(BASE_REPO_DIR)
	mkdir -p $(RELEASE_DIR)/lib
	mkdir -p $(RELEASE_DIR)/include

clone:	
	[[ -d $(REPO_CLONE_DIR) ]] || git clone --recurse-submodules https://github.com/$(REPO) $(REPO_CLONE_DIR)
	#cd $(REPO_CLONE_DIR)/. && git pull || { git reset --hard && git pull; }
	echo OK $(REPO_CLONE_DIR)
#	color green black
#	find $(REPO_CLONE_DIR)/themes -type f -name "*.theme.bash" | xargs -I % basename % .bash | xargs -I % basename % .theme|sort -u |tee $(THEMES_FILE)
	color reset

clean:
	rm -rf /root/go-bash-bridge/src/dist/c_scriptexec

build:
	cd $(REPO_CLONE_DIR) && ./build.sh
	cd $(REPO_CLONE_DIR) && cmake .
	cd $(REPO_CLONE_DIR) && make

install:
	rsync $(REPO_CLONE_DIR)/include/*.h $(RELEASE_DIR)/include
	rsync $(REPO_CLONE_DIR)/lib/*.a $(RELEASE_DIR)/lib
