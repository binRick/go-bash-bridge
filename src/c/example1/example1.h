#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <ctype.h>

struct myExampleStruct1 {
	char *name;
	int qty;
};

void myStructPrinter(char *name);
