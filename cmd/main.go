package main

import (
	"fmt"
	"log"
	"time"

	"inu.org/hello"
)

type logWriter struct {
}

func (writer logWriter) Write(bytes []byte) (int, error) {
	return fmt.Println(time.Now().UTC().Format("2006-01-02T15:04:05.999Z"), string(bytes))
}

func main() {
	log.SetFlags(0)
	log.SetOutput(&logWriter{})

	greeting := hello.Hello()
	log.Println(greeting)
}
