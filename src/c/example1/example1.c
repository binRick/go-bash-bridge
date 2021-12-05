#include "example1.h"

void myStructPrinter(char *s) {
	fprintf(stderr, "[%d] %s> %s\n", 
    getpid(),
    "example_lib1", 
    s
  );
}


char * CHAR_TEST() {
	return "Hello there\0";
}

int INT_TEST(int a, int b) {
	return a + b;
}
