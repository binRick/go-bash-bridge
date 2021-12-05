#ifndef _CSO1LIB_H_
#define _CSO1LIB_H_

#include <stdio.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include <ctype.h>

struct cso1Struct1 {
	char *name;
	int qty;
};

void mycso1Struct1Printer(char *name);
extern char * cso1_CHAR_TEST();
extern int cso1_INT_TEST(int, int);

#endif
