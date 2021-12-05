package main

import (
	"sync"
)

import "C"

var count int
var mtx sync.Mutex

//export Add_libgoso1
func Add_libgoso1(a, b int) int {
	return a + b
}

func main() {}
