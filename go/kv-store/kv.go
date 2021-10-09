// TODO: some interesting ideas from:
//
// https://dgraph.io/docs/badger/get-started/
// - a sequence API, allow returning named monotomically increasing numbers. This is probably more useful with persistence
// - allow specifying a duration for a key, so it will be GC'd after time is up
// - some form of persistence would be nice, so store can be restored if the service is restarted
//   - ultimately this also ties in to having a more efficient backing store other than maps
// - not specifically at the link, but want the ability to allow concurrent access
//   - atomic operations?
//   - should setup test programs, benchmarks, and a chaos monkey
// - At some point, separate the backing key/value store from the web interface. KV store is a GO library whereas web is potentially a library, and a front-end program
// - other ideas??
//

package main

import (
  "net/http"
  "fmt"
  "log"
  "io/ioutil"
  "os"
  "sort"
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

type Value struct {
  Data []byte
  ContentType string
}

// TODO: not thread safe!
//  see: https://eli.thegreenplace.net/2019/on-concurrency-in-go-http-servers
type Sequence map[string]int
func (m *Sequence) ServeHTTP(w http.ResponseWriter, req *http.Request) {
  switch req.Method {
  case "GET":
    if val, ok := (*m)[req.URL.Path]; ok {
      (*m)[req.URL.Path] = val + 1
    } else {
      (*m)[req.URL.Path] = 0
    }
    fmt.Fprintln(w, (*m)[req.URL.Path])
  case "DELETE":
    delete((*m), req.URL.Path)
    fmt.Fprintln(w, "Deleted sequence")
  }
}

type Map map[string]Value

// TODO: not thread safe!
func (m *Map) ServeHTTP(w http.ResponseWriter, req *http.Request) {
  switch req.Method {
  case "GET":
    if val, ok := (*m)[req.URL.Path]; ok {
      w.Header().Set("Content-Type", val.ContentType)
      w.Write(val.Data)
    } else {
      w.WriteHeader(http.StatusNotFound)
      fmt.Fprintln(w, "Resource not found")
    }
  case "POST", "PUT":
    b, err := ioutil.ReadAll(req.Body)
    if err != nil {
      log.Fatalln(err)
    }
    var val Value
    val.ContentType = req.Header.Get("Content-Type")
    val.Data = b //string(b)

    (*m)[req.URL.Path] = val
    fmt.Fprintln(w, "Stored value")
  case "DELETE":
    delete((*m), req.URL.Path)
    fmt.Fprintln(w, "Deleted value")
  }
}

func main() {
  mux := http.NewServeMux()
  ctr := new(Counter)
  m := make(Map)
  s := make(Sequence)

  // Background on http handlers -
  // https://stackoverflow.com/questions/6564558/wildcards-in-the-pattern-for-http-handlefunc
  // https://www.honeybadger.io/blog/go-web-services/
  mux.Handle("/api/args", http.HandlerFunc(ArgServer))
  mux.Handle("/api/counter", ctr)
  //mux.HandleFunc("/api/dump", TODO: func
  mux.HandleFunc("/api/stats", func(w http.ResponseWriter, req *http.Request) {
    fmt.Fprintln(w, "Number of key/value pairs = ", len(m))
    fmt.Fprintln(w, "Keys:")
    keys := make([]string, len(m))
    i := 0
    for k := range m {
      keys[i] = k
      i++
      //fmt.Fprintln(w, k)
    }
    sort.Strings(keys)
    for _, k := range keys {
      fmt.Fprintln(w, k)
    }
  })
  mux.Handle("/seq/", &s)
  mux.Handle("/kv/", &m)
  
  // TODO: allow optionally running an HTTPS server based on command-line flag(s):
  // https://medium.com/rungo/secure-https-servers-in-go-a783008b36da
  
  log.Fatal(http.ListenAndServe(":8080", mux))
}
