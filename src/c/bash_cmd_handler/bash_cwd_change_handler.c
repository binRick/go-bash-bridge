#include "slog.h"
#include "cry.h"
#include <stdio.h>

#define CHAN_ENABLED      0
#define STDERR_ENABLED    1
#define LOGGER_ENABLED    0
#define CRY_ENABLED       0


#define LOGFILE           "/tmp/go-bash-bridge-bash-cwd-events.log"
#define LOGFORMAT         "[%l] %d/%M/%y (%ps): %L"

#define NDEBUG            1
#define CRY_SIMPLE        (-1337)
#define CRY_INFO          (3)
#define CRY_FATAL         (1337)

slog_stream *logger;
int         logger_setup = 0;
cry_t       cwd_cry;

void * bash_event_handler()
{
    if (STDERR_ENABLED)
    {
        fprintf(stderr, "<%d> bash_event_handler>\n", getpid());
    }
    if (CRY_ENABLED == 1)
    {
        cry(&cwd_cry, "t123");
    }
    if (LOGGER_ENABLED == 1)
    {
        slog_printf(logger, slog_loglevel_message, "<%d> log_handler: %s", getpid(), "xxxxxxxxxxxxxx");
    }

/*
 * void *job;
 * while (chan_recv(bash_events_chan, &job) == 0){
 *  if(DEBUG_MODE==1)
 *    printf("received job %s\n", (char *)job);
 * }
 *
 * if(DEBUG_MODE==1)
 *  printf("received all jobs\n");
 * chan_send(bash_events_done, "1");
 */
}


//static  __attribute__((__constructor__(65535))) void setup_log_file(void){


/*
 * static __attribute__((__constructor__)) void __bcw__initialize (){
 * if(log_setup == 0){
 * log_setup = 1;
 *  fprintf(stderr,"<%d> handle_cwd_handler Constructor>\n", getpid());
 *  bash_events_chan = chan_init(CHANNEL_DEPTH);
 *  bash_events_done = chan_init(0);
 *
 *  logger = slog_create (LOGFILE, slog_flags_color);
 *  if (!logger) {
 *    fprintf(stderr,"<%d> failed to open log file\n", getpid());
 *  }else{
 *    fprintf(stderr,"<%d> opened log file\n", getpid());
 * //     slog_suppress (logger, SLOG_SUPPRESS_NOTHING);
 * //   slog_format (logger, LOGFORMAT);
 *  }
 * }
 *  slog_printf (logger, slog_loglevel_message, "%s", "START");
 * }
 */

/*
 * static  __attribute__((__destructor__(65535))) void close_log_file(void){
 * fprintf(stderr,"<%d> handle_bash_closing......>>>>>>>\n", getpid());
 * slog_close (logger);
 * chan_dispose(bash_events_chan);
 * chan_dispose(bash_events_done);
 * fprintf(stderr,"<%d> handle_bash_closed\n", getpid());
 * }
 */
int log_handler(char *msg)
{
    if (logger_setup == 0)
    {
        logger_setup = 1;
        if (STDERR_ENABLED)
        {
            fprintf(stderr, "<%d> handle_cwd_handler Constructor>\n", getpid());
        }
        if (CRY_ENABLED == 1)
        {
            cwd_cry = cry_new(1, "CWD");
        }
        if (CHAN_ENABLED)
        {
            bash_events_chan = chan_init(CHANNEL_DEPTH);
            bash_events_done = chan_init(0);
        }
        if (LOGGER_ENABLED == 1)
        {
            logger = slog_create(LOGFILE, slog_flags_color);
            if (!logger)
            {
                fprintf(stderr, "<%d> failed to open log file\n", getpid());
            }
            else
            {
                fprintf(stderr, "<%d> opened log file\n", getpid());
            }
        }
    }
    pthread_t th;
    pthread_create(&th, NULL, bash_event_handler, NULL);
    return 0;
}


void handle_bash_init(char *dirname)
{
    // log_handler(dirname);

/*
 * chan_send(bash_events_chan, (char *)dirname);
 * if(DEBUG_MODE==1)
 *  printf("sent job!\n");
 *
 * chan_close(bash_events_chan);
 *
 * if(DEBUG_MODE==1)
 *  printf("sent all bash_events_chan\n");
 *
 * chan_recv(bash_events_done, NULL);
 *
 * if(DEBUG_MODE==1)
 *  printf("job has been processed\n");
 */
}
