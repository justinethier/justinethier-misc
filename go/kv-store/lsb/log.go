// TODO: none of this is thread safe!!

package lsb

import (
    "bufio"
    "encoding/json"
    "os"
)

type Value struct {
  Data []byte
  ContentType string
}

type Log struct {
  Key string
  Data []byte
  ContentType string
  Deleted bool
}

func AppendLog(filename string, data interface{}) {
  f, err := os.OpenFile(filename, os.O_APPEND|os.O_WRONLY|os.O_CREATE, 0600)
  if err != nil {
    panic(err)
  }

  defer f.Close()

  b, err := json.Marshal(data)
  if err != nil {
    panic(err)
  }

  _, err = f.Write(b)
  if err != nil {
    panic(err)
  }

  _, err = f.Write([]byte("\n"))
  if err != nil {
    panic(err)
  }
}

// From: https://stackoverflow.com/a/12206584
//
// Readln returns a single line (without the ending \n)
// from the input buffered reader.
// An error is returned iff there is an error with the
// buffered reader.
func Readln(r *bufio.Reader) (string, error) {
  var (isPrefix bool = true
       err error = nil
       line, ln []byte
      )
  for isPrefix && err == nil {
      line, isPrefix, err = r.ReadLine()
      ln = append(ln, line...)
  }
  return string(ln),err
}

func ReadLog(filename string) []Log {
    var buf []Log
    f, err := os.Open(filename)
    if err != nil {
      return buf
    }

    defer f.Close()

    r := bufio.NewReader(f)
    s, e := Readln(r)
    for e == nil {
        var data Log
        err = json.Unmarshal([]byte(s), &data)
        //fmt.Println(data)
        buf = append(buf, data)
        s,e = Readln(r)
    }

    return buf
}

func ResetDB() {
  os.Remove("store.json")
}

func set(key string, value Value, deleted bool) {
  l := Log { Key: key, Data: value.Data, ContentType: value.ContentType, Deleted: deleted }
  AppendLog("store.json", l)
}

func Set(key string, value Value) {
  set(key, value, false)
}

func Delete(key string) {
  set(key, Value{Data: nil, ContentType: ""}, true)
}

func Get(key string) (Value, bool) {
  log := ReadLog("store.json")

  for i := len(log) - 1; i >= 0; i-- {
    if log[i].Key == key {
      return Value {Data: log[i].Data, ContentType: log[i].ContentType}, true
    }
  }

  return nil, false
}
