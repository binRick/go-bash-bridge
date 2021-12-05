#include <stdio.h>
#include "goso1.h"

int main() {
    //Call golang Add_goso1 function
    GoInt a = 12;
    GoInt b = 99;
    fprintf(stderr, "[%d] %s> goso1.Add_goso1(%d,%d) = %d\n", 
      getpid(), 
      "call_goso1", 
      a, b,
      Add_goso1(a, b)
    ); 
  
}

