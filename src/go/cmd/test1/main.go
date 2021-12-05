package test1

/*
#cgo CFLAGS: -g -Wall
#cgo LDFLAGS: -L. -llibbash
#include "./../../../../go-bash-bridge/src/c/bash.h"
*/

import (
	"fmt"
	"os"

	gbb "github.com/go-bash-bridge/src/go/gbb"
)

func ExampleRegister() {
	gbb.Register("hello", hello)
	status := gbb.Main([]string{os.Args[0], "-c", "hello world"}, os.Environ())
	fmt.Println("exit status", status)
	// Output:
	// Hello from Go! args=[world]
	// exit status 42
}

func hello(args ...string) (status int) {
	fmt.Printf("Hello from Go! args=%v\n", args)
	return 42
}
