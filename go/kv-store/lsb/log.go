package lsb

import (
    "bufio"
    "encoding/json"
    "fmt"
    "io/ioutil"
    "os"
)

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
    f, err := os.Open(filename)
    if err != nil {
      panic(err)
    }
    var buf []Log
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
