package basic

/*
#cgo CFLAGS: -g -Wall -fPIC
#cgo LDFLAGS: -L../../RELEASE/lib
#include "./../../../../../go-bash-bridge/RELEASE/lib"
*/
import "C"
import (
	"fmt"
	"os"

	gbb "github.com/binRick/go-bash-bridge/src/go/gbb"
	//	gbb "github.com/binRick/go-bash-bridge/src/go/gbb"
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

func main() {
	fmt.Println("CGO MAIN")
	ExampleRegister()
}
