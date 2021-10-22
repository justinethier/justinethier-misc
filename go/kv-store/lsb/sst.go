// TODO: not thread safe!
package lsb

import (
    "log"
    "fmt"
    "io/ioutil"
    "regexp"
    "strconv"
)

type SstBuf struct {
  Path string
  Buffer []SstEntry
  MaxBufferLength int
}

type SstEntry struct {
  Key string
  Value interface{}
  Deleted bool
}

func NewSstBuf(path string, bufSize int) *SstBuf {
  var buf []SstEntry
  return &SstBuf{path, buf, bufSize}
}

func (s *SstBuf) Set(k string, value interface{}, deleted bool) {
  entry := SstEntry{k, value, deleted}
  (*s).Buffer = append((*s).Buffer, entry)

  if (len((*s).Buffer) < (*s).MaxBufferLength) {
    // Buffer is not full yet, we're good
    return
  }

  //TODO: (*s).Flush()
}

// TODO:
//func (s *SstBuf) Flush() {
//  if len((*s).Buffer) == 0 {
//    return
//  }
//
//  // TODO: remove duplicates from buffer
//
//
//  // TODO: sort list
//
//  // TODO: flush buffer to disk
//  var filename = (*s).NextSstFilename()
//
//  var buf []SstEntry
//  (*s).buffer = buf
//}

func (s *SstBuf) NextSstFilename() string {
  files, err := ioutil.ReadDir((*s).Path)
  if err != nil {
      log.Fatal(err)
  }

  var sstFiles []string
  for _, file := range files {
    matched, _ := regexp.Match(`^sorted-string-table-[0-9]*\.json`, []byte(file.Name()))
    if matched && !file.IsDir() {
      //fmt.Println(file.Name(), file.IsDir())
      sstFiles = append(sstFiles, file.Name())
    }
  }

  if len(sstFiles) > 0 {
    var latest = sstFiles[len(sstFiles)-1][20:24]
    n, _ := strconv.Atoi(latest)
    return fmt.Sprintf("sorted-string-table-%04d.json", n + 1)
  }

  return "sorted-string-table-0000.json"
}

