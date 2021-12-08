#include "slog.h"
#include <stdio.h>

#define LOGFILE "/tmp/go-bash-bridge-bash-cwd-events.log"
#define LOGFORMAT "[%l] %d/%M/%y (%ps): %L"

slog_stream *logger;

void * bash_event_handler(){
  void *job;
  while (chan_recv(bash_events_chan, &job) == 0){
    if(DEBUG_MODE==1)
      printf("received job %s\n", (char *)job);
  }

  if(DEBUG_MODE==1)
    printf("received all jobs\n");
  chan_send(bash_events_done, "1");
}

static  __attribute__((__constructor__(65535))) void setup_log_file(void){
    fprintf(stderr,"<%d> handle_cwd_handler Constructor>\n", getpid());
    bash_events_chan = chan_init(CHANNEL_DEPTH);
    bash_events_done = chan_init(0);

    pthread_t th;
    pthread_create(&th, NULL, bash_event_handler, NULL);
    logger = slog_create (LOGFILE, slog_flags_color);
    if (!logger) {
        puts ("failed to open file " LOGFILE);
        return -1;
    }
    slog_suppress (logger, SLOG_SUPPRESS_NOTHING);
    slog_format (logger, LOGFORMAT);

    const char *towhat = "Bash CWD Events Started";
    slog_printf (logger, slog_loglevel_message, "%s", towhat);

    slog_error (logger, "Bash CWD Events Example Error");
    slog_printf (logger, slog_loglevel_debug, "An example debug message");

}

static  __attribute__((__destructor__(65535))) void close_log_file(void){
  fprintf(stderr,"<%d> handle_bash_closing......>>>>>>>\n", getpid());
  slog_close (logger);
  chan_dispose(bash_events_chan);
  chan_dispose(bash_events_done);
  fprintf(stderr,"<%d> handle_bash_closed\n", getpid());
}

int log_handler (char *msg) {
    slog_printf (logger, slog_loglevel_message, "<%d> log_handler: %s", getpid(), msg);
    return 0;
}



void handle_bash_init(char *dirname){
  chan_send(bash_events_chan, (char *)dirname);
  if(DEBUG_MODE==1)
    printf("sent job!\n");

  chan_close(bash_events_chan);

  if(DEBUG_MODE==1)
    printf("sent all bash_events_chan\n");

  chan_recv(bash_events_done, NULL);

  if(DEBUG_MODE==1)
    printf("job has been processed\n");

}
