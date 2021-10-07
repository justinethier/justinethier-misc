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

  fmt.Fprintf(w, "%s", req.Method)

// rewrite as switch, see:
// https://www.golangprograms.com/example-to-handle-get-and-post-request-in-golang.html
  if req.Method == "GET" {
  } else if req.Method == "POST" {

    // TODO: do this, or just read body instead of trying to have sub key/values??
    req.ParseForm()

    for key, value := range req.Form {
      (*m)[req.URL.Path + "/" + key] = value
    }
  }

  //if val, ok := (*m)[req.URL.Path]; ok {
  //  fmt.Fprintln(w, "Previous value", val)
  //}

  //(*m)[req.URL.Path] = req.Method

  //values := req.URL.Query()
  //for k, v := range values {
  //    fmt.Println(k, " => ", v)
  //}

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
  //mux.Handle("/api/stats", TODO: func
// possibly use a func like this:
//http.HandleFunc("/bar", func(w http.ResponseWriter, r *http.Request) {
//	fmt.Fprintf(w, "Hello, %q", html.EscapeString(r.URL.Path))
//})
  mux.Handle("/", &m)
  log.Fatal(http.ListenAndServe(":8080", mux))
}
