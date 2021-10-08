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

type Key struct {
  Data []byte
  ContentType string
}

type Map map[string]Key
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
    var key Key
    key.ContentType = req.Header.Get("Content-Type")
    key.Data = b //string(b)

    (*m)[req.URL.Path] = key
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
  mux.Handle("/", &m)
  log.Fatal(http.ListenAndServe(":8080", mux))
}
