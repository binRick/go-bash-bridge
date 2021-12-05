#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

typedef long long go_int;

int main() {
    void *handle;
    char *error;

    handle = dlopen ("libgoso1.so", RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }
    go_int a = 12;
    go_int b = 98;
/*
    fprintf(stderr, "[%d] %s> libgoso1.Add_libgoso1(%d,%d) = %d\n", 
      getpid(), 
      "(main.c) call_libgoso1", 
      a, b,
      Add_libgoso1(a, b)
    ); 
*/
    dlclose(handle);

}

