#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "seethe.h"
#include <sysexits.h>




void handle_bash_cmd(){
  fprintf(stderr,"<%d> handle_bash_cmd>\n", getpid());
  return;
}
