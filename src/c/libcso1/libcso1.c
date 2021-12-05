#include "libcso1.h"

void mycso1Struct1Printer(char *s) {
	fprintf(stderr, "[%d] %s> %s\n", 
    getpid(),
    "cso1 Shared Object", 
    s
  );
}

char * cso1_CHAR_TEST() {
	return "Hello there\0";
}

int cso1_INT_TEST(int a, int b) {
	return a + b;
}
