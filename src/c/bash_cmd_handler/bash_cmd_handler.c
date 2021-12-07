#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include "seethe.h"
#include <sysexits.h>
#include "chan.h"
#include "chan.c"
#include "queue.h"
#include "queue.c"
//#include "chan.c"
#include "cmd_chan.c"




void handle_bash_cd(char *dirname){
  fprintf(stderr,"<%d> handle_bash_cd> Dirname: %s\n", getpid(), dirname);
  main_worker();
  return;
}

void handle_bash_cmd(){
  fprintf(stderr,"<%d> handle_bash_cmd>\n", getpid());
  return;
}
