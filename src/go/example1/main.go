package main

/*
#include "./../../../RELEASE/include/example1.h"
#cgo LDFLAGS: -lexample1 -L../../../RELEASE/lib
*/
import "C"

import (
	"fmt"
	"os"
)

const NAME = "EXAMPLE1_GO"

func debug(msg string) {
	fmt.Fprintf(stderr, "<%d> [%s] :: %s\n",
		os.Getpid(),
		NAME,
		msg,
	)
}

func main() {
	debug("main init")
	debug("main end")
	//fmt.Println(C.addSomeNumbers(2, 45))
}
