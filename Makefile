BULK_MAKEFILES = log.c lwlog seethe cry chan slog ttyd c_scriptexec bash-it oh-my-bash
GITHUB_USER=git@
GITHUB_PROTO=ssh

###  clone to src/dist/github/${AUTHOR}-${REPO}
BULK_GITHUB_REPOS = mlichvar/newt clibs/debug kdm9/clogged JoshuaS3/lognestmonster AriaPahlavan/clog tiborvass/whatfiles silentbicycle/loom silentbicycle/socket99 zserge/pt DaanDeMeyer/reproc /aklomp/base64 tiborvass/whatfiles fclaerho/armada chunqian/icecream-c xfgusta/hr brunexgeek/waitkey cwchentw/clibs brunexgeek/waitkey weiss/c99-snprintf 0x1C1B/libexc ararslan/termcolor-c armanirodriguez/ansifade Bowuigi/color BryanHaley/libvterm-ctrl kalexey89/libdye kilobyte/colorized-logs mdk97/Rainbow mlabbe/ansicodes rdtrob/unix-shell shakibamoshiri/bline Valen-H/Ansi binRick/gatling hypercore-cxx/uv-async septag/sx stephenmathieson/batch.c clibs/flag clibs/timer clibs/timestamp Constellation/console-colors.c jwerle/strsplit.h nami-doc/trim.c stephenmathieson/batch.c trws/libdefer tylertreat/chan willemt/file2str littlstar/b64.c mbucc/chtmlescape littlstar/uri.c jb55/is_number.c

BULK_GITHUB_REPOS_AUTOMAKE = kdm9/clogged silentbicycle/loom silentbicycle/socket99 zserge/pt /aklomp/base64 tiborvass/whatfiles fclaerho/armada xfgusta/hr brunexgeek/waitkey cwchentw/clibs Valen-H/Ansi armanirodriguez/ansifade kalexey89/libdye 0x1C1B/libexc binRick/gatling stephenmathieson/batch.c
BULK_GITHUB_REPOS_AUTOCMAKE = brunexgeek/waitkey septag/sx
BULK_GITHUB_REPOS_AUTOGEN = weiss/c99-snprintf mlichvar/newt
BULK_GITHUB_REPOS_AUTO_ARCHIVES = Valen-H/Ansi/libansi.a
BULK_GITHUB_REPOS_AUTO_SHARED_OBJECTS = Valen-H/Ansi:libansi.so


MAKE ?= make
MKDIR=mkdir -p
BASE_DIR=/root/go-bash-bridge
RELEASE_DIR=$(BASE_DIR)/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
RELEASE_BIN_DIR=$(RELEASE_DIR)/bin
RELEASE_INCLUDE_DIR=$(RELEASE_DIR)/include
EXEC_ENV=LD_LIBRARY_PATH=$(RELEASE_LIB_DIR)
GOSO1=./src/go/libgoso1
GOCALLCSO1=./src/go/call_libcso1
CSO1=libcso1
CSO1_PATH=./src/c/$(CSO1)
CCALLGOSO1=./src/c/call_libgoso1
BASH_PATH=./src/bash
GH=$(BASE_DIR)/src/dist/github

all: all_pre makefiles bash libgoso1 libcso1 call_libgoso1 call_libcso1 list validate py

all_pre: 
	direnv allow .

bash: makefiles
	$(MAKE) -C $(BASH_PATH)

libgoso1:
	$(MAKE) -C $(GOSO1)

call_libgoso1:
	$(MAKE) -C $(CCALLGOSO1)

libcso1:
	$(MAKE) -C $(CSO1_PATH)

call_libcso1:
	$(MAKE) -C $(GOCALLCSO1)

include Makefiles/main-clean.Makefile

init:
	$(MKDIR) src/dist/github
	$(MKDIR) $(RELEASE_BIN_DIR)
	$(MKDIR) $(RELEASE_LIB_DIR)
	$(MKDIR) $(RELEASE_INCLUDE_DIR)

list:
	color green black
	find $(RELEASE_DIR) -type f
	color reset

include Makefiles/main-validate.Makefile

py:
	./src/py/call_libso/py2.sh
	./src/py/call_libso/py3.sh

makefiles: init makes srcs ## Execute all Makefiles

clib: 
	make -C Makefiles -f clib.Makefile

ttyd: 
	echo make -f Makefiles/ttyd.Makefile

slog: 
	make -B -f Makefiles/slog.Makefile 2>&1 | pv -l -N slog  
#>/dev/null

bash-it: 
	make -f Makefiles/bash-it.Makefile 2>&1 | pv -l -N bash-it  >/dev/null

apps: ttyd

makes: slog bash-it apps ## Execute Dist Makefiles
	color yellow
	make -f Makefiles/chan.Makefile 2>&1 | pv -l -N chan >/dev/null
	make -f Makefiles/c_scriptexec.Makefile 2>&1 | pv -l -N c_scriptexec >/dev/null
	make -f Makefiles/oh-my-bash.Makefile 2>&1 | pv -l -N oh-my-bash >/dev/null
	make -f Makefiles/seethe.Makefile 2>&1 | pv -l -N seethe >/dev/null
	color reset

srcs_clean:
	make -C src/c/bash_cmd_handler -w -f Makefile clean

srcs: ## Execute Custom App Makefiles
	make -C src/c/bash_cmd_handler -w -f Makefile all

bulk: bulk_makefiles

bulk_makefiles:
	cd Makefiles/. && $(foreach mf,$(BULK_MAKEFILES),eval make -f $(mf).Makefile;)

repos: bulk_github_repos makes

makes: bulk_github_repos make cmake autogen

AUTOMAKE_CMDS="find $(RELEASE_DIR)/src/dist/github |grep '/makefile$$' -i|xargs -I % dirname % | xargs -I % echo -e 'cd %/. && make'"

a:
	@echo AUTOMAKE_CMDS=$(AUTOMAKE_CMDS)
	cd src/dist/github/. && eval "$(AUTOMAKE_CMDS)" | bash 

bulk_github_repos: init
	cd src/dist/github/. && $(foreach br,$(BULK_GITHUB_REPOS),eval git clone $(GITHUB_PROTO)://$(GITHUB_USER)github.com/$(br) $(BASE_DIR)/src/dist/github/$(shell echo $(br) | tr '/' '-')||true ;)
make: init
	cd src/dist/github/. && $(foreach br,$(BULK_GITHUB_REPOS_AUTOMAKE),eval cd $(BASE_DIR)/src/dist/github/$(shell echo $(br) | tr '/' '-') && { hr||echo; } && ansi --yellow --italic --bold --blink -n "Running Automake on" && echo -ne " :: " && ansi --cyan --bold "$(br)" && { hr||echo; } && pwd && ls && { make || { make clean && make||true; } } && { hr||echo; };)
cmake:
	cd src/dist/github/. && $(foreach br,$(BULK_GITHUB_REPOS_AUTOCMAKE),eval cd $(BASE_DIR)/src/dist/github/$(shell echo $(br) | tr '/' '-') && { hr||echo; } && ansi --yellow --italic --bold --blink -n "Running Automake on" && echo -ne " :: " && ansi --cyan --bold "$(br)" && { hr||echo; } && pwd && ls && cmake . && { make || { make clean && make||true; } } && { hr||echo; };)
autogen:
	cd src/dist/github/. && $(foreach br,$(BULK_GITHUB_REPOS_AUTOGEN),eval cd $(BASE_DIR)/src/dist/github/$(shell echo $(br) | tr '/' '-') && { hr||echo; } && ansi --yellow --italic --bold --blink -n "Running Automake on" && echo -ne " :: " && ansi --cyan --bold "$(br)" && { hr||echo; } && pwd && ls && ./autogen.sh && ./configure && { make || { make clean && make||true; } } && { hr||echo; };)

so: auto_shared_objects auto_shared_objects_make_include

auto_shared_objects:
	cd src/dist/github/. && $(foreach br,$(BULK_GITHUB_REPOS_AUTO_SHARED_OBJECTS),eval rsync -v $(GH)/$(shell echo -e "$(br)"|tr '/' '-'|tr ':' '/') $(RELEASE_LIB_DIR)/.;)

#cd $(BASE_DIR)/src/dist/github/$(shell echo $(br) | tr '/' '-') && { hr||echo; } && ansi --yellow --italic --bold --blink -n "Installing Shared Objects" && echo -ne $(br)" :: " && ansi --cyan --bold "$(br)" && { hr||echo; }; } && pwd; })

auto_shared_objects_make_include:
	@$(foreach br,$(BULK_GITHUB_REPOS_AUTO_SHARED_OBJECTS),eval echo -e "-l$(shell echo $(br)|cut -d: -f2|sed 's/.so//g'|sed 's/^lib//g') ";)
