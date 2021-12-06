#ifndef _CSO1LIB_H_
#define _CSO1LIB_H_
#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>
#include <dlfcn.h>
#include <signal.h>
#include <execinfo.h>

void libcso1_TEST_SIGNAL(int);
typedef void (*fcallback)();
extern fcallback foo();
extern void registerIt(fcallback callback);


struct libcso1Struct1 {
	char *name;
	int qty;
};

void libcso1Struct1Printer(char *name);
extern char * libcso1_CHAR_TEST();
extern int libcso1_INT_TEST(int, int);





static void handleSigSegv(int signum, siginfo_t *info, void *ctx) {
	printf("Caught SIGSEGV\n");

	int max_trace_size = 16;
	void *trace[max_trace_size];
	char **messages = (char **)NULL;
	int i, trace_size = 0;

	trace_size = backtrace(trace, max_trace_size);

	messages = backtrace_symbols(trace, trace_size);
	for (i = 0; i < trace_size; ++i) {
		printf("[cgo backtrace] %s\n", messages[i]);
	}

	free(messages);
	fflush(stdout);
	exit(1);
}

static void __attribute__ ((constructor)) init(void) {
  fprintf(stderr, "<%d> libcso1 constructor> %s\n", getpid(), "ok");
	struct sigaction action;
	memset(&action, 0, sizeof action);
	sigfillset(&action.sa_mask);
	action.sa_sigaction = handleSigSegv;
	action.sa_flags =  SA_NOCLDSTOP | SA_SIGINFO | SA_ONSTACK | SA_RESTART;
	sigaction(SIGSEGV, &action, NULL);
}


#endif
