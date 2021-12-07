#include "seethe.h"
#include <sysexits.h>
#include "bash_cmd_handler.c"



int main(argc, argv) int argc; char **argv;{
  handle_bash_cmd();
  return 0;
}

