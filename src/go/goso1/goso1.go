package main

import (
	"sync"
)

import "C"

var count int
var mtx sync.Mutex

//export Add_goso1
func Add_goso1(a, b int) int {
	return a + b
}

func main() {}
