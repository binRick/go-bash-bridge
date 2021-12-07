#include "slog.h"
#include <stdio.h>

#define LOGFILE "/tmp/go-bash-bridge-bash-cwd-events.log"
#define LOGFORMAT "[%l] %d/%M/%y (%ps): %L"

int log_handler (void) {
    slog_stream *logger = slog_create (LOGFILE, slog_flags_color);
    if (!logger) {
        puts ("failed to open file " LOGFILE);
        return -1;
    }
    slog_suppress (logger, SLOG_SUPPRESS_NOTHING);
    slog_format (logger, LOGFORMAT);

    const char *towhat = "Bash CWD Events";
    slog_printf (logger, slog_loglevel_message, "%s", towhat);

    slog_error (logger, "Bash CWD Events Error");
    slog_printf (logger, slog_loglevel_debug, "A debug message");
    slog_close (logger);
    return 0;
}


void * bash_event_handler(){
  void *job;
  while (chan_recv(bash_events_chan, &job) == 0){
    if(DEBUG_MODE==1)
      printf("received job %s\n", (char *)job);
  }

  if(DEBUG_MODE==1)
    printf("received all jobs\n");
  chan_send(bash_events_done, "1");
  return NULL;
}

void handle_bash_close(){
  fprintf(stderr,"<%d> handle_bash_closing\n", getpid());
  chan_dispose(bash_events_chan);
  chan_dispose(bash_events_done);
  fprintf(stderr,"<%d> handle_bash_closed\n", getpid());
}

void handle_bash_init(char *dirname){
  fprintf(stderr,"<%d> handle_bash_init\n", getpid());
  bash_events_chan = chan_init(CHANNEL_DEPTH);
  bash_events_done = chan_init(0);

  pthread_t th;
  pthread_create(&th, NULL, bash_event_handler, NULL);
  int i;
  for (i = 1; i <= 3; i++){
    chan_send(bash_events_chan, (char *)dirname);
    if(DEBUG_MODE==1)
      printf("sent job %d\n", i);
  }
  chan_close(bash_events_chan);
  if(DEBUG_MODE==1)
  printf("sent all bash_events_chan\n");

  chan_recv(bash_events_done, NULL);
  handle_bash_close();
}
