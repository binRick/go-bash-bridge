#include "libcso1.h"

/*
void set_GoString(GoString *str_g, char *str) {
    if (!str_g || !str) {
        return;
    }
    str_g->p = str;
    str_g->n = (GoInt)strlen(str);
}
*/


void libcso1Struct1Printer(char *s) {
	fprintf(stderr, "[%d] %s> %s\n", 
    getpid(),
    "libcso1 Shared Object", 
    s
  );
}

char * libcso1_CHAR_TEST() {
	return "Hello there\0";
}

int libcso1_INT_TEST(int a, int b) {
	return a + b;
}



int *p;

void libcso1_TEST_SIGNAL(int i) {
	// Call libcso1_TEST_SIGNAL recursively a few times to build up the stack for more
	// interesting backtrace output.
	if (i == 3) {
		printf("Causing intention SIGSEGV\n");
		fflush(stdout);
		// Assignment to undefined memory address causes segfault.
		*p = 1;
	}
	libcso1_TEST_SIGNAL(++i);
}

void myCallback() {
  puts("C> myCallback");
}

void registerIt(fcallback callback) {
  puts("C> registerIt");
  callback();
}

fcallback foo() {
  puts("C> foo");
  return myCallback;
}

/* int main() { */
/*   puts("C: main"); */
/*   registerIt(foo()); */
/* } */
