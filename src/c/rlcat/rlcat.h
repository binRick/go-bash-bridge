#if defined (HAVE_CONFIG_H)
#  include <config.h>
#endif

#ifdef HAVE_UNISTD_H
#  include <unistd.h>
#endif

#include <sys/types.h>
#include "posixstat.h"

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>

#ifdef HAVE_STDLIB_H
#  include <stdlib.h>
#else
extern void exit();
#endif

#ifndef errno
extern int errno;
#endif

#if defined (READLINE_LIBRARY)
#  include "readline.h"
#  include "history.h"
#else
#  include <readline/readline.h>
#  include <readline/history.h>
#endif


extern int optind;
extern char *optarg;

static int stdcat();

static char *progname;
static int vflag;

