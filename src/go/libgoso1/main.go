package main

import (
	"fmt"
	"sync"
	"unsafe"
)

import "C"

var count int
var mtx sync.Mutex

/*
 * Dummy main function
 */
func main() {}

/*
 * int, int -> int
 */
//export Add_libgoso1
func Add_libgoso1(a, b int) int {
	return a + b
}

/*
 * string -> string
 */
//export make_greet
func make_greet(x string) uintptr {
	buf := []byte(fmt.Sprintf("Hello, %s!", x))
	return uintptr(unsafe.Pointer(&buf[0]))
}

/*
 * (int,int) -> (int, int)
 */
//export mydiv
func mydiv(x, y int) (answer, remainder int) {
	answer = x / y
	remainder = x % y
	return
}
