#include <errno.h>
#include <limits.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sysexits.h>

#include "seethe.h"
#include "chan.h"
#include "chan.c"
#include "queue.h"
#include "queue.c"

#define DEBUG_MODE 0
#define CHANNEL_DEPTH 5

chan_t *bash_events_chan;
chan_t *bash_events_done;

#include "bash_cwd_change_handler.c"

void handle_bash_cd(char *dirname){
  fprintf(stderr,"<%d> handle_bash_cd> Dirname: %s\n", getpid(), dirname);
  handle_bash_init(dirname);
}

void handle_bash_cmd(){
  fprintf(stderr,"<%d> handle_bash_cmd>\n", getpid());
}
