#include "example1.h"

void myStructPrinter(char *s) {
	fprintf(stderr, "[%d] %s> %s\n", 
    getpid(),
    "example_lib1", 
    s
  );
}

