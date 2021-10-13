package cache

import (
  "net/http"
  "fmt"
  "log"
  "io/ioutil"
  "sync"
)

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

type Map struct {
  Data map[string]Value
  Lock sync.RWMutex
}

func NewMap() *Map {
  m := make(map[string]Value)
  l := sync.RWMutex{}
  return &Map{m, l}
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

