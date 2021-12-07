
EXECUTABLES = example
RM=rm -f
CFLAGS  = -g -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib -I /root/go-bash-bridge/src/dist/bash-5.1.8/include  -DREADLINE_LIBRARY -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -I ./repos -I ./deps -I /root/go-bash-bridge/RELEASE/include
LDFLAGS = -g -L /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -L/root/go-bash-bridge/src/dist/bash-5.1.8/lib -L /root/go-bash-bridge/RELEASE/lib -I /root/go-bash-bridge/RELEASE/include

.c.o:
	$(CC) $(CFLAGS) -c $<

all: libs $(EXECUTABLES) test

libs:
	#cc -g -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib -I /root/go-bash-bridge/src/dist/bash-5.1.8/include  -DREADLINE_LIBRARY -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -I ./repos -I ./deps -I /root/go-bash-bridge/RELEASE/include -c rlcat.c
	#$(CC) $(LDFLAGS) $(CFLAGS) bash_cmd_handler.c
# -lreadline -ltermcap -lscriptexec -lchan

bash_cmd_handler.o: bash_cmd_handler.c

test:
	echo ./bash_cmd_handler --help

clean:
	$(RM) bash_cmd_handler bash_cmd_handler.o example

install:
	rsync bash_cmd_handler.o ~/go-bash-bridge/RELEASE/lib/.
