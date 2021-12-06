#ifndef LIBGOSO1__H
#define LIBGOSO1__H

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

#define BASE_NAME "main"

void helloworld();
int square(int x);
int add(int x, int y);
char* make_greet(char *x);
void free_greet(char *x);

typedef struct {
    int answer;
    int remainder;
} MyDiv;

MyDiv *mydiv(int, int);
int mydiv_answer(MyDiv *x);
int mydiv_remainder(MyDiv *x);
void mydiv_free(MyDiv *x);


#endif /* LIBGOSO1__H */
