//go:build static
// +build static

package main

/*
#include "/root/go-bash-bridge/RELEASE/include/libcso1.h"
#cgo LDFLAGS: -lcso1 -L/root/go-bash-bridge/RELEASE/lib
#cgo CFLAGS: -I/root/go-bash-bridge/RELEASE/include
*/
import "C"

import (
	"fmt"
	"os"
	"time"

	"github.com/k0kubun/pp"
)

var TEST_SIGNAL_HANDLER = false

var REGISTER_CALLBACK = true
var DEFAULT_TEST_SIGNAL_HANDLER = false
var TSH = os.Getenv("TEST_SIGNAL_HANDLER")

const NAME = "CALL_CSO1......."

func init() {
	if DEFAULT_TEST_SIGNAL_HANDLER {
		TEST_SIGNAL_HANDLER = true
	}
	if TSH == `true` {
		TEST_SIGNAL_HANDLER = true
	}
}

//  C.registerIt(C.foo())

func do_callback() error {
	return nil
}

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
	debug("main                      init     ", time.Now().Unix())
	debug("main  libcso1_INT_TEST 5 + 10=     ", C.libcso1_INT_TEST(5, 10))
	debug("main                       end     ", time.Now().Unix())
	if REGISTER_CALLBACK {
		C.registerIt(C.foo())
	}
	if TEST_SIGNAL_HANDLER {
		C.libcso1_TEST_SIGNAL(0)
	}
}
