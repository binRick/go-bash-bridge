
EXECUTABLES = example
RM=rm -f
CFLAGS  = -g -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib -I /root/go-bash-bridge/src/dist/bash-5.1.8/include  -DREADLINE_LIBRARY -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -I ./repos -I ./deps -I /root/go-bash-bridge/RELEASE/include
LDFLAGS = -g -L /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -L/root/go-bash-bridge/src/dist/bash-5.1.8/lib -L /root/go-bash-bridge/RELEASE/lib -I /root/go-bash-bridge/RELEASE/include -lpthread

.c.o:
	$(CC) $(CFLAGS) -c $<
init:
	mkdir -p ~/go-bash-bridge/RELEASE/lib

all: libs $(EXECUTABLES) test install

libs: bash_cmd_handler.o

bash_cmd_handler.o:
	$(CC) $(LDFLAGS) $(CFLAGS) -c bash_cmd_handler.c

test:
	./example --help

clean:
	$(RM) bash_cmd_handler bash_cmd_handler.o example

install: init
	rsync bash_cmd_handler.o ~/go-bash-bridge/RELEASE/lib/.
	rsync example ~/go-bash-bridge/RELEASE/bin/bash-cmd-handler-example
