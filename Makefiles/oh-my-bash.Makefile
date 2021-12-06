

REPO=https://github.com/ohmybash/oh-my-bash
BASE_DIR=/root/go-bash-bridge
DIST_DIR=$(BASE_DIR)/src/dist
BASE_REPO_DIR=$(DIST_DIR)/oh-my-bash
REPO_CLONE_DIR=$(BASE_REPO_DIR)/repo
THEMES_FILE=$(BASE_REPO_DIR)/themes.txt

all: init build

init:
	mkdir -p $(BASE_REPO_DIR)

build:	
	[[ -d $(REPO_CLONE_DIR) ]] || git clone --recurse-submodules $(REPO) $(REPO_CLONE_DIR)
	#cd $(REPO_CLONE_DIR)/. && git pull || { git reset --hard && git pull; }
	echo OK $(REPO_CLONE_DIR)
#	color green black
#	find $(REPO_CLONE_DIR)/themes -type f -name "*.theme.bash" | xargs -I % basename % .bash | xargs -I % basename % .theme|sort -u |tee $(THEMES_FILE)
	color reset

clean:
	rm -rf /root/go-bash-bridge/src/dist/oh-my-bash
