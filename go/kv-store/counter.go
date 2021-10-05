package main

import (
  "net/http"
  "fmt"
  "log"
  "os"
)

type Handler interface {
    ServeHTTP(http.ResponseWriter, *http.Request)
}

// Simpler counter server.
type Counter int

func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    *ctr++
    fmt.Fprintf(w, "counter = %d\n", *ctr)
}

// TODO: probably want the channel to be buffered
type Chan chan *http.Request

func (ch Chan) ServeHTTP(w http.ResponseWriter, req *http.Request) {
  ch <- req
  fmt.Fprint(w, "notification sent")
}

func ArgServer(w http.ResponseWriter, req *http.Request) {
  fmt.Fprintln(w, os.Args)
}

type Map map[string]string
func (m *Map) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintf(w, "map %s", req.URL.Path)
}

func main() {
  ctr := new(Counter)
  http.Handle("/counter", ctr)
  http.Handle("/args", http.HandlerFunc(ArgServer))

  m := new(Map)
  // TODO: wildcard does not work but see: https://stackoverflow.com/questions/6564558/wildcards-in-the-pattern-for-http-handlefunc
  http.Handle("/kv/*", m)
  log.Fatal(http.ListenAndServe(":8080", nil))
}
