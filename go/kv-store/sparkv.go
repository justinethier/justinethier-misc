// TODO: some interesting ideas from:
//
// https://dgraph.io/docs/badger/get-started/
// - allow specifying a duration for a key, so it will be GC'd after time is up
// - some form of persistence would be nice, so store can be restored if the service is restarted
//   - ultimately this also ties in to having a more efficient backing store other than maps
// - should setup test programs, benchmarks, and a chaos monkey
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
  "sync"
)

// Simpler counter server.
type Counter int

func (ctr *Counter) ServeHTTP(w http.ResponseWriter, req *http.Request) {
    *ctr++
    fmt.Fprintf(w, "counter = %d\n", *ctr)
}

// TODO: probably want the channel to be buffered
//type Chan chan *http.Request
//
//func (ch Chan) ServeHTTP(w http.ResponseWriter, req *http.Request) {
//  ch <- req
//  fmt.Fprint(w, "notification sent")
//}

func ArgServer(w http.ResponseWriter, req *http.Request) {
  fmt.Fprintln(w, os.Args)
}

type Value struct {
  Data []byte
  ContentType string
}

// Regarding concurrency / safety see:
//  https://eli.thegreenplace.net/2019/on-concurrency-in-go-http-servers
//  https://stackoverflow.com/questions/45585589/golang-fatal-error-concurrent-map-read-and-map-write/45585833
//
// FUTURE: Consider using a syncmap to improve performance with many cores
type Sequence struct {
  Data map[string]int
  Lock sync.RWMutex
}

func NewSequence() *Sequence {
  m := make(map[string]int)
  l := sync.RWMutex{}
  return &Sequence{m, l}
}

func (m *Sequence) ServeHTTP(w http.ResponseWriter, req *http.Request) {
  switch req.Method {
  case "GET":
    (*m).Lock.Lock()
    if val, ok := (*m).Data[req.URL.Path]; ok {
      (*m).Data[req.URL.Path] = val + 1
    } else {
      (*m).Data[req.URL.Path] = 0
    }
    fmt.Fprintln(w, (*m).Data[req.URL.Path])
    (*m).Lock.Unlock()
  case "DELETE":
    (*m).Lock.Lock()
    delete((*m).Data, req.URL.Path)
    (*m).Lock.Unlock()
    fmt.Fprintln(w, "Deleted sequence")
  }
}

type Map struct {
  Data map[string]Value
  Lock sync.RWMutex
}

func NewMap() *Map {
  m := make(map[string]Value)
  l := sync.RWMutex{}
  return &Map{m, l}
}

func (m *Map) ServeHTTP(w http.ResponseWriter, req *http.Request) {
  switch req.Method {
  case "GET":
    (*m).Lock.RLock()
    if val, ok := (*m).Data[req.URL.Path]; ok {
      w.Header().Set("Content-Type", val.ContentType)
      w.Write(val.Data)
    } else {
      w.WriteHeader(http.StatusNotFound)
      fmt.Fprintln(w, "Resource not found")
    }
    (*m).Lock.RUnlock()
  case "POST", "PUT":
    b, err := ioutil.ReadAll(req.Body)
    if err != nil {
      log.Fatalln(err)
    }
    var val Value
    val.ContentType = req.Header.Get("Content-Type")
    val.Data = b //string(b)

    (*m).Lock.Lock()
    (*m).Data[req.URL.Path] = val
    (*m).Lock.Unlock()
    fmt.Fprintln(w, "Stored value")
  case "DELETE":
    (*m).Lock.Lock()
    delete((*m).Data, req.URL.Path)
    (*m).Lock.Unlock()
    fmt.Fprintln(w, "Deleted value")
  }
}

func main() {
  mux := http.NewServeMux()
  ctr := new(Counter)
  m := NewMap()
  s := NewSequence()

  // Background on http handlers -
  // https://stackoverflow.com/questions/6564558/wildcards-in-the-pattern-for-http-handlefunc
  // https://www.honeybadger.io/blog/go-web-services/
  mux.Handle("/api/args", http.HandlerFunc(ArgServer))
  mux.Handle("/api/counter", ctr)
  mux.HandleFunc("/api/stats", func(w http.ResponseWriter, req *http.Request) {
    (*m).Lock.RLock()
    fmt.Fprintln(w, "Number of key/value pairs = ", len(m.Data))
    fmt.Fprintln(w, "Keys:")
    keys := make([]string, len(m.Data))
    i := 0
    for k := range m.Data {
      keys[i] = k
      i++
      //fmt.Fprintln(w, k)
    }
    sort.Strings(keys)
    for _, k := range keys {
      fmt.Fprintln(w, k)
    }
    (*m).Lock.RUnlock()
  })
  mux.Handle("/seq/", s)
  mux.Handle("/kv/", m)

  // TODO: allow optionally running an HTTPS server based on command-line flag(s):
  // https://medium.com/rungo/secure-https-servers-in-go-a783008b36da

  log.Fatal(http.ListenAndServe(":8080", mux))
}
