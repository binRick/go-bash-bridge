#include "rlcat.h"

static void
usage()
{
  fprintf (stderr, "%s: usage: %s [-vEVN] [filename]\n", progname, progname);
}

int main (argc, argv) int argc; char **argv; {
  char *temp;
  int opt, Vflag, Nflag;

  progname = strrchr(argv[0], '/');
  if (progname == 0)
    progname = argv[0];
  else
    progname++;

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
	  usage ();
	  exit (2);
	}
    }

  argc -= optind;
  argv += optind;

  if (isatty(0) == 0 || argc || Nflag)
    return stdcat(argc, argv);

  rl_variable_bind ("editing-mode", Vflag ? "vi" : "emacs");
  while (temp = readline (""))
    {
      if (*temp)
        add_history (temp);
      printf ("%s\n", temp);
    }

  return (ferror (stdout));
}

static int
fcopy(fp)
     FILE *fp;
{
  int c;
  char *x;

  while ((c = getc(fp)) != EOF)
    {
      if (vflag && isascii ((unsigned char)c) && isprint((unsigned char)c) == 0)
	{
	  x = rl_untranslate_keyseq (c);
	  if (fputs (x, stdout) == EOF)
	    return 1;
	}
      else if (putchar (c) == EOF)
        return 1;
    }
  return (ferror (stdout));
}

int stdcat (argc, argv) int argc; char **argv;{ 
  int  i, fd, r;
  char *s;
  FILE *fp;

  if (argc == 0)
    return (fcopy(stdin));

  for (i = 0, r = 1; i < argc; i++)
    {
      if (*argv[i] == '-' && argv[i][1] == 0)
	fp = stdin;
      else
	{
	  fp = fopen (argv[i], "r");
	  if (fp == 0)
	    {
	      fprintf (stderr, "%s: %s: cannot open: %s\n", progname, argv[i], strerror(errno));
	      continue;
	    }
        }
      r = fcopy (fp);
      if (fp != stdin)
	fclose(fp);
    }
  return r;
}
