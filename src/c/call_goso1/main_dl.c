#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>
#include "/root/go-bash-bridge/RELEASE/include/goso1.h"

typedef long long go_int;


int main() {
    void *handle;
    char *error;

    handle = dlopen ("goso1.so", RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }
    go_int a = 12;
    go_int b = 98;
    fprintf(stderr, "[%d] %s> goso1.Add_goso1(%d,%d) = %d\n", 
      getpid(), 
      "(main.c) call_goso1", 
      a, b,
      Add_goso1(a, b)
    ); 
    dlclose(handle);

}

