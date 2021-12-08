.DEFAULT_GOAL := all
ENABLED_CLIB_DEPS_FILTER="cry.h|xxxxx"


EXECUTABLES = example
RM=rm -f
LINKED_LIBS=-lpthread -lslog
BASE_DIR=/root/go-bash-bridge
RELEASE_DIR=$(BASE_DIR)/RELEASE
RELEASE_LIB_DIR=$(RELEASE_DIR)/lib
CLIB_DEP_DIRS=$(shell find $(BASE_DIR)/src/dist/clibs -name "*.h"|xargs -I % dirname %|sort -u|egrep $(ENABLED_CLIB_DEPS_FILTER)|while read -r d; do echo -I$$d; done)

CFLAGS  = -g -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib -I /root/go-bash-bridge/src/dist/bash-5.1.8/include  -DREADLINE_LIBRARY -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -I ./repos -I ./deps -I /root/go-bash-bridge/RELEASE/include $(CLIB_DEP_DIRS)
LDFLAGS = -g -L /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -L/root/go-bash-bridge/src/dist/bash-5.1.8/lib -L /root/go-bash-bridge/RELEASE/lib -I /root/go-bash-bridge/RELEASE/include $(LINKED_LIBS) -L $(RELEASE_LIB_DIR)

r:
	@color green black
	@color bd
	@echo CLIB_DEP_DIRS=$(CLIB_DEP_DIRS)
	@color reset

all: rm-release libs $(EXECUTABLES) test install

.c.o:
	$(CC) $(CFLAGS) -c $<

init: ## Initialize Paths
	@color ul
	@color green white
	@echo "Initializing"
	@color reset
	@color green black
	mkdir -p ~/go-bash-bridge/RELEASE/lib
	@color reset

libs: bash_cmd_handler.o

slog:
#	cd ./../../../. && make -f Makefile -B slog
	cd ./../../../Makefiles && make -f slog.Makefile install -B

bash_cmd_handler.o: slog
	$(CC) $(LDFLAGS) $(CFLAGS) -c bash_cmd_handler.c

rm-release:
	$(RM) $(RELEASE_DIR)/lib/bash_cmd_handler.o

test:
	env LD_LIBRARY_PATH=./ ./example --help
#	env LD_LIBRARY_PATH=$(RELEASE_LIB_DIR) ./example --help

clean:
	$(RM) bash_cmd_handler bash_cmd_handler.o example

install: init
	rsync bash_cmd_handler.o ~/go-bash-bridge/RELEASE/lib/.
	rsync example ~/go-bash-bridge/RELEASE/bin/bash-cmd-handler-example
