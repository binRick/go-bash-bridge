package main

/*
#include "./../../../RELEASE/include/cso1.h"
#cgo LDFLAGS: -lcso1 -L../../../RELEASE/lib
*/
import "C"

import (
	"fmt"
	"os"
	"time"

	"github.com/k0kubun/pp"
)

const NAME = "CALL_CSO1"

func debug(msg string, dat interface{}) {
	dat = pp.Sprintf(`%s`, dat)
	fmt.Fprintf(os.Stderr, "<%d> [%s] :: %s | %s\n",
		os.Getpid(),
		NAME,
		msg,
		dat,
	)
}

func main() {
	debug("main      init             ", time.Now().Unix())
	debug("main  cso1_INT_TEST 5 + 10=", C.cso1_INT_TEST(5, 10))
	debug("main       end             ", time.Now().Unix())
}
