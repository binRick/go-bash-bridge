#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
//#include "goso1/_obj/_cgo_export.h"
//#include "goso1/_obj/_cgo_export.c"
//#include "goso1/_obj/main.cgo2.c"

//typedef long long go_int;


int main() {
    void *handle;
    char *error;

    handle = dlopen ("./../lib/goso1.so", RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }
    int a = 12;
    int b = 99;
/*
    //Call golang Add_goso1 function
    GoInt a = 12;
    GoInt b = 99;
    fprintf(stderr, "[%d] %s> goso1.Add_goso1(%d,%d) = %d\n", 
      getpid(), 
      "call_goso1", 
      a, b,
      Add_goso1(a, b)
    ); 
*/
/*
*/
    dlclose(handle);

}

