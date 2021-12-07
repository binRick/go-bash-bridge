#include "rlcat.h"
#include "seethe/seethe.h"
#include "deps/progressbar/progressbar.h"
#include "timestamp/timestamp.h"
#include "timestamp/timestamp.c"
#include "file/file.h"
#include "file/file.c"
#include "term/term.h"
#include "term/term.c"
#include "bytes/bytes.h"
#include "bytes/bytes.c"
#include "loom/loom.h"
#include "loom/loom.c"
//#include "X/X.c"
//#include "X/X.c"
//#include "ms/ms.h"
//#include "ms/ms.c"
#include "cry.h/cry.h"
#include <sysexits.h>
#include "chan/chan.c"
#include "chan/chan.h"
#include "chan/queue.c"
#include "chan/queue.h"
#define CRY_SIMPLE    (-1337)
#define CRY_FATAL     (1337)

#include "chan.c"
#include "bchan.c"

/*
 * //#include "progress/progress.h"
 #include "progress/progress.h"
 * void
 * on_progress (progress_data_t *data);
 *
 * int
 * pm (void) {
 * progress_t *progress = progress_new(100, 60);
 * progress->fmt = "progress [:bar] :percent :elapsed";
 *
 * // listen for progress
 * progress_on(progress, PROGRESS_EVENT_PROGRESS, on_progress);
 *
 * // tick progress
 * progress_tick(progress, 10);
 * }
 *
 * void
 * on_progress (progress_data_t *data) {
 * progress_write(data->holder);
 * }
 *
 */
#define LOG_LEVEL          SILENT
#define LOG_LEVEL          WARNING
#define LOG_LEVEL          ERROR
#define LOG_LEVEL          DEBUG
#define MSG_ENDING         "\n"
#define TIME_FORMAT        "%T "
#define BORDER             "->"

#define DISPLAY_COLOUR     1
#define DISPLAY_TIME       1
#define DISPLAY_LEVEL      1
#define DISPLAY_FUNC       1
#define DISPLAY_FILE       1
#define DISPLAY_LINE       1
#define DISPLAY_BORDER     1
#define DISPLAY_MESSAGE    1
#define DISPLAY_ENDING     1
#define DISPLAY_RESET      1


#define DEBUG_COLOUR       "\x1B[36m"
#define INFO_COLOUR        "\x1B[36m"
#define NOTICE_COLOUR      "\x1B[32;1m"
#define WARNING_COLOUR     "\x1B[33m"
#define ERROR_COLOUR       "\x1B[31m"
#define CRITICAL_COLOUR    "\x1B[41;1m"

#define RETRY_COUNT        5


static struct loom *l = NULL;

#define MAX_TASKS    1025

static void sleep_msec(int msec)
{
    poll(NULL, 0, msec);
}


static struct test_context
{
    int       limit;
    int       flags[MAX_TASKS];
    uintptr_t cleanup_counter;
}
context;



static void task_cb(void *env)
{
    uintptr_t i = (uintptr_t)env;

    //printf(" == set_flag_cb %zd\n",i);
    context.flags[i] = i;
}


static void cleanup_cb(void *env)
{
    (void)env;
    assert(false);  // all tasks should run
}


int do_cry()
{
    cry_t simple_cry = cry_new(CRY_SIMPLE, "CRY_SIMPLE");
    cry_t fatal_cry  = cry_fatal_new(CRY_FATAL, "CRY_FATAL", true, EX_USAGE);

    cry(&simple_cry, "Crying simply");
    cry(&fatal_cry, "Crying for last time boi");

    // This will get ignored lel
    return 0;
}


void pm()
{
//progressbar *progress = progressbar_new("Loading",100);
    for (int i = 0; i < 5; i++)
    {
        loom_config cfg =
        {
            // Number of threads to start upfront; more will start on demand.
            .init_threads = 0,

            // Max number of threads too run
            .max_threads  = 8,

            // Max msec. idle threads should sleep, to avoid busywaiting.
            // They will be awakened when new tasks are added.
            .max_delay    = 1000,

            // Base-2 log of the task queue size (e.g. 10 => 1024 tasks).
            // A larger size uses more memory, but allows more flexibility in
            // the backlog size before it fills up.
            .ring_sz2     = 8,
        };
        struct loom *l = NULL;

        if (LOOM_INIT_RES_OK != loom_init(&cfg, &l)) /* error... */ }
    {
        loom_task task =
        {
            // Task callback: void task_cb(void *closure_environment) {}
            .task_cb    = task_cb,

            // Cleanup callback: Called to free *env if task is canceled.
            .cleanup_cb = cleanup_cb,

            // void * to a data to pass to the callbacks.
            .env        = (void *)i,
        }


        ;

        int i = 0;
        for (i = 0; i < RETRY_COUNT; i++)
        {
            size_t backpressure = 0;

            /* Retry adding task, pushing back if the queue is
             * currently full and cannot schedule more tasks. */
            if (loom_enqueue(l, &task, &backpressure))
            {
                break;
            }
            //       do_pushback(backpressure);
        }
        if (i == RETRY_COUNT) /* failed to enqueue -- queue full */ }
    {
        debug("debug log");
        //info("informational log. Timestamp: %lld", timestamp());
        //info("informational log. Timestamp: milliseconds_to_string-> %s", milliseconds_to_string(timestamp()/1000));
        //info("informational log. Timestamp: milliseconds_to_long_string-> %s", milliseconds_to_long_string(timestamp()/1000));
        notice("notice log");
        warning("warning log");
        error("error log");
//    error("bytes_to_string 99999> %s", bytes_to_string(99999));
        critical("critical log");

        term_bold();
        term_underline();
        printf("bold and underlined\n");

        term_reset();
        printf("reset\n");

        term_color("green");
        printf("ok\n");

        term_bold();
        term_color("red");
        term_background("red");
        printf("fail");
        term_reset();


        int w = 0, h = 0;
        term_size(&w, &h);
        printf("%dx%d\n", w, h);

        term_bold();
        term_color("red");
        term_background("red");
        printf("fail");
        term_reset();
        term_show_cursor();

        // Do some stuff
        // progressbar_inc(progress);
//sleep(1);
}
//progressbar_finish(progress);
}


static void
usage()
{
    fprintf(stderr, "%s: usage: %s [-vEVN] [filename]\n", progname, progname);
}


int main(argc, argv) int argc;

char **argv;
{
    char *temp;
    int opt, Vflag, Nflag;



    do_chan();
    do_bchan();
//pm();
//term_hide_cursor();
//do_cry();

    progname = strrchr(argv[0], '/');
    if (progname == 0)
    {
        progname = argv[0];
    }
    else
    {
        progname++;
    }

    vflag = Vflag = Nflag = 0;
    while ((opt = getopt(argc, argv, "vEVN")) != EOF)
    {
        switch (opt)
        {
        case 'v':
            vflag = 1;
            break;

        case 'V':
            Vflag = 1;
            break;

        case 'E':
            Vflag = 0;
            break;

        case 'N':
            Nflag = 1;
            break;

        default:
            usage();
            exit(2);
        }
    }

    argc -= optind;
    argv += optind;

    if ((isatty(0) == 0) || argc || Nflag)
    {
        return stdcat(argc, argv);
    }

    rl_variable_bind("editing-mode", Vflag ? "vi" : "emacs");
    while (temp = readline(""))
    {
        if (*temp)
        {
            add_history(temp);
        }
        printf("%s\n", temp);
    }

    return(ferror(stdout));
}

static int
fcopy(fp)
FILE *fp;

{
    int c;
    char *x;

    while ((c = getc(fp)) != EOF)
    {
        if (vflag && isascii((unsigned char)c) && (isprint((unsigned char)c) == 0))
        {
            x = rl_untranslate_keyseq(c);
            if (fputs(x, stdout) == EOF)
            {
                return 1;
            }
        }
        else if (putchar(c) == EOF)
        {
            return 1;
        }
    }
    return(ferror(stdout));
}

int stdcat(argc, argv) int argc;

char **argv;
{
    int i, fd, r;
    char *s;
    FILE *fp;

    if (argc == 0)
    {
        return(fcopy(stdin));
    }

    for (i = 0, r = 1; i < argc; i++)
    {
        if ((*argv[i] == '-') && (argv[i][1] == 0))
        {
            fp = stdin;
        }
        else
        {
            fp = fopen(argv[i], "r");
            if (fp == 0)
            {
                fprintf(stderr, "%s: %s: cannot open: %s\n", progname, argv[i], strerror(errno));
                continue;
            }
        }
        r = fcopy(fp);
        if (fp != stdin)
        {
            fclose(fp);
        }
    }
    return r;
}
