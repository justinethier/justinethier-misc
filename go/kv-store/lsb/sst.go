// TODO: not thread safe!
package lsb

import (
  "encoding/json"
  "fmt"
  "io/ioutil"
  "log"
  "os"
  "regexp"
  "sort"
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

func (s *SstBuf) Set(k string, value interface{}) {
  (*s).set(k, value, false)
}

func (s *SstBuf) Delete(k string) {
  (*s).set(k, nil, true)
}

func (s *SstBuf) set(k string, value interface{}, deleted bool) {
  entry := SstEntry{k, value, deleted}
  (*s).Buffer = append((*s).Buffer, entry)

  if (len((*s).Buffer) < (*s).MaxBufferLength) {
    // Buffer is not full yet, we're good
    return
  }

  (*s).Flush()
}

func (s *SstBuf) Flush() {
  if len((*s).Buffer) == 0 {
    return
  }

  // Remove duplicate entries
  m := make(map[string]SstEntry)
  for _, e := range (*s).Buffer {
    m[e.Key] = e
  }

  // sort list of keys
  keys := make([]string, 0, len(m))
  for k := range m {
    keys = append(keys, k)
  }
  sort.Strings(keys)

  // Flush buffer to disk
  var filename = (*s).NextSstFilename()
  CreateSstFile(filename, keys, m)

  // Clear buffer
  var buf []SstEntry
  (*s).Buffer = buf
}

func check(e error) {
  if e != nil {
    panic(e)
  }
}

func CreateSstFile(filename string, keys []string, m map[string]SstEntry) {
  f, err := os.Create(filename)
  check(err)

  defer f.Close()

  for _, k := range keys {
    b, err := json.Marshal(m[k])
    check(err)

    _, err = f.Write(b)
    check(err)

    _, err = f.Write([]byte("\n"))
    check(err)
  }
}

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

// TODO:
// func (s *SstBuf) Get(k string) (interface{}, bool) {}
// func (s *SstBuf) FindLatestBufferEntryValue(key string) {}
// func (s *SstBuf) LoadEntriesFromSstFile(filename string) {}
// func (s *SstBuf) FindEntryValue(key string, entries []Buffer) {}
//
// reset() - delete all sst files

