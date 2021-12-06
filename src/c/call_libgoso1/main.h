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
int Add_libgoso1(int x, int y);
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

/*
void set_GoString(GoString *str_g, char *str) {
    if (!str_g || !str) {
        return;
    }
    str_g->p = str;
    str_g->n = (GoInt)strlen(str);
}
*/

/*
void test_fxn(){
    int x, y;
    char *name, *msg;
//    struct mydiv_return r;

  //  helloworld();

    x = 111;
    printf("square(%d) = %d\n", x, square(x));

    x = 123;
    y = 654;
//    printf("add(%d, %d) = %d\n", x, y, myadd(x, y));

    name = "DARK STAR";
 //   msg = (char*)make_greet(name);
   // printf("%s\n", msg);

    x = 1000;
    y = 17;
//    r = mydiv(x, y);
//    printf("%d / %d = %d ... %d\n", x, y, r.r0, r.r1);

}
*/

#endif /* LIBGOSO1__H */
