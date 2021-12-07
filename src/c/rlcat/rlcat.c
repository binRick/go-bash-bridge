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
#include "rlcat.h"


#include "seethe.h"
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
//#include "ms/ms.h"
//#include "ms/ms.c"
#include "cry.h/cry.h"
#include <sysexits.h>
#include "chan/chan.c"
#include "chan/chan.h"
#include "chan/queue.c"
#include "chan/queue.h"
#include "dbg/dbg.h"
#define CRY_SIMPLE    (-1337)
#define CRY_FATAL     (1337)

#include "chan.c"
#include "bchan.c"
#include "flag.c"
#include "scriptexec.c"

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


static void
usage()
{
    fprintf(stderr, "%s: usage: %s [-vEVN] [filename]\n", progname, progname);
}


int main(argc, argv) int argc;

char **argv;
{
    char *temp;
    int  opt, Vflag, Nflag;


    const char *s = "hello world";


    do_flag(argc, argv);
    do_bchan();
    scriptexec_main();

    //   dbg(s, %s);
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
    int  c;
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
    int  i, fd, r;
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
