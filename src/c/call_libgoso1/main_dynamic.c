#include "main.h"
//#include "/root/go-bash-bridge/RELEASE/include/libgoso1.h"
#define NAME "dynamic"
#define THIS_FILE "main_dynamic.c"
#define SHARED_LIBRARY "libgoso1.so"

typedef long long go_int;

int main() {
    void *handle;
    char *error;

    handle = dlopen (SHARED_LIBRARY, RTLD_LAZY);
    if (!handle) {
        fputs (dlerror(), stderr);
        exit(1);
    }
    go_int a = 12;
    go_int b = 98;
    fprintf(stderr, "<%d> (%s) [%s::%s] %s> libgoso1.Add_libgoso1(%d,%d) = %d\n", 
      getpid(), 
      THIS_FILE,
      BASE_NAME,
      NAME,
      "call_libgoso1", 
      a, b,
      Add_libgoso1(a, b)
    ); 
    dlclose(handle);

}

