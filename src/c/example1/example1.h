#ifndef _EXAMPLE1LIB_H_
#define _EXAMPLE1LIB_H_

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

extern char * CHAR_TEST();
extern int INT_TEST(int, int);

#endif
