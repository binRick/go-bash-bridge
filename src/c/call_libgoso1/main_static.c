#include "main.h"
//#include "/root/go-bash-bridge/RELEASE/include/libgoso1.h"

int main() {
    void *handle;
    char *error;

    go_int a = 12;
    go_int b = 98;
    fprintf(stderr, "<%d> [%s] libgoso1.Add_libgoso1(%d,%d) = %d\n", 
      getpid(), 
      "(main.c) call_libgoso1", 
      a, b,
      Add_libgoso1(a, b)
    ); 
    dlclose(handle);

}

