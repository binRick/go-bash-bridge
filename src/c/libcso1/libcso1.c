#include "libcso1.h"

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
