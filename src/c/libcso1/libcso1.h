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





// handleSigSegv is the action that we replace for the default SIGSEGV handler.
// It sends some useful debugging information to STDOUT and then exits, otherwise
// it would be called endlessly as we haven't/can't fix the actual fault.
static void handleSigSegv(int signum, siginfo_t *info, void *ctx) {
	printf("Caught SIGSEGV\n");

	// If the backtrace is larger than max_trace_size, then the addresses
	// corresponding to the max_trace_size most recent function calls are
	// returned.
	int max_trace_size = 16;
	void *trace[max_trace_size];
	char **messages = (char **)NULL;
	int i, trace_size = 0;

	trace_size = backtrace(trace, max_trace_size);

	// Translates memory addresses in trace to function names using symbols.
	messages = backtrace_symbols(trace, trace_size);
	for (i = 0; i < trace_size; ++i) {
		printf("[cgo backtrace] %s\n", messages[i]);
	}

	free(messages);
	fflush(stdout);

	// Without exit program execution continues from where the fault happened,
	// which would get caught in a loop by this handler.
	exit(1);
}

// Set up the signal handlers in a high priority constructor,
// so that they are installed before the Go code starts.
// gcc magic: https://gcc.gnu.org/onlinedocs/gcc-3.0.1/gcc_5.html#SEC93
static void __attribute__ ((constructor)) init(void) {
  fprintf(stderr, "<%d> libcso1 constructor> %s\n", getpid(), "ok");
	struct sigaction action;
	// Set the first <sizeof action> bytes to 0.
	memset(&action, 0, sizeof action);
	// Set signal mask to default POSIX set, this should be okay because this
	// runs outside of a Go created thread.
	sigfillset(&action.sa_mask);
	// Our new signal handler.
	action.sa_sigaction = handleSigSegv;
	// SA_ONSTACK and SA_RESTART are specified in cgo docs as required to
	// avoid crashes.
	action.sa_flags =  SA_NOCLDSTOP | SA_SIGINFO | SA_ONSTACK | SA_RESTART;
	// Set the new action for SIGSEGV to &action.
	sigaction(SIGSEGV, &action, NULL);
}


#endif
