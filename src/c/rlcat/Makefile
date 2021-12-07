EXECUTABLES = rlcat
RM=rm -f
CFLAGS  = -g -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib -I /root/go-bash-bridge/src/dist/bash-5.1.8/include  -DREADLINE_LIBRARY -I /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -I ./repos -I ./deps -I /root/go-bash-bridge/RELEASE/include
LDFLAGS = -g -L /root/go-bash-bridge/src/dist/bash-5.1.8/lib/readline -L/root/go-bash-bridge/src/dist/bash-5.1.8/lib -L /root/go-bash-bridge/RELEASE/lib

.c.o:
	$(CC) $(CFLAGS) -c $<

all: $(EXECUTABLES) test

rlcat: clean rlcat.o
	$(CC) $(LDFLAGS) -o $@ rlcat.o -lreadline -ltermcap -lscriptexec -lchan


rlcat.o: rlcat.c

test:
	clear
	./rlcat --help
	cat /etc/passwd |head -n5 | ./rlcat ./.dat

clean:
	$(RM) rlcat rlcat.o
