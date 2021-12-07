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
//#include "cmd_chan.c"

#define CHANNEL_DEPTH 5
chan_t *bash_events_chan;
chan_t *bash_events_done;

void * bash_event_handler(){
    void *job;
    while (chan_recv(bash_events_chan, &job) == 0){
        printf("received job %s\n", (char *)job);
    }

    printf("received all jobs\n");
    chan_send(bash_events_done, "1");
    return NULL;
}

void handle_bash_close(){
  fprintf(stderr,"<%d> handle_bash_close %s\n", getpid());

    chan_dispose(bash_events_chan);
    chan_dispose(bash_events_done);
}

void handle_bash_init(char *dirname){
  fprintf(stderr,"<%d> handle_bash_init\n", getpid());
  bash_events_chan = chan_init(CHANNEL_DEPTH);
  bash_events_done = chan_init(0);

  pthread_t th;
  pthread_create(&th, NULL, bash_event_handler, NULL);

    int i;

    for (i = 1; i <= 3; i++)
    {
        chan_send(bash_events_chan, (char *)dirname);
        printf("sent job %d\n", i);
    }
    chan_close(bash_events_chan);
    printf("sent all bash_events_chan\n");

    // Wait for all bash_events_chan to be received.
    chan_recv(bash_events_done, NULL);

    // Clean up channels.
}

void handle_bash_cd(char *dirname){
  fprintf(stderr,"<%d> handle_bash_cd> Dirname: %s\n", getpid(), dirname);
  //main_worker();
  handle_bash_init(dirname);
}

void handle_bash_cmd(){
  fprintf(stderr,"<%d> handle_bash_cmd>\n", getpid());
}
