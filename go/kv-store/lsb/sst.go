// TODO: not thread safe!
package lsb

import (
  "bufio"
  "encoding/json"
  "fmt"
  "io/ioutil"
  "log"
//  "math"
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
  Value Value
  Deleted bool
}

func NewSstBuf(path string, bufSize int) *SstBuf {
  var buf []SstEntry
  return &SstBuf{path, buf, bufSize}
}

func (s *SstBuf) Set(k string, value Value) {
  (*s).set(k, value, false)
}

func (s *SstBuf) Delete(k string) {
  var val Value
  (*s).set(k, val, true)
}

func (s *SstBuf) set(k string, value Value, deleted bool) {
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

func (s *SstBuf) GetSstFilenames() []string {
  files, err := ioutil.ReadDir((*s).Path)
  if err != nil {
      log.Fatal(err)
  }

  var sstFiles []string
  for _, file := range files {
    matched, _ := regexp.Match(`^sorted-string-table-[0-9]*\.json`, []byte(file.Name()))
    if matched && !file.IsDir() {
      sstFiles = append(sstFiles, file.Name())
    }
  }

  return sstFiles
}

func (s *SstBuf) findLatestBufferEntryValue(key string) (SstEntry, bool){
  var empty SstEntry
  for _, entry := range (*s).Buffer {
    if entry.Key == key {
      return entry, true
    }
  }

  return empty, false
}

func (s *SstBuf) LoadEntriesFromSstFile(filename string) []SstEntry{
  var buf []SstEntry

    f, err := os.Open(filename)
    if err != nil {
      return buf
    }

    defer f.Close()

    r := bufio.NewReader(f)
    str, e := Readln(r)
    for e == nil {
        var data SstEntry
        err = json.Unmarshal([]byte(str), &data)
        //fmt.Println(data)
        buf = append(buf, data)
        str, e = Readln(r)
    }

  return buf
}

// From: https://stackoverflow.com/a/12206584
//
// Readln returns a single line (without the ending \n)
// from the input buffered reader.
// An error is returned iff there is an error with the
// buffered reader.
//func Readln(r *bufio.Reader) (string, error) {
//  var (isPrefix bool = true
//       err error = nil
//       line, ln []byte
//      )
//  for isPrefix && err == nil {
//      line, isPrefix, err = r.ReadLine()
//      ln = append(ln, line...)
//  }
//  return string(ln),err
//}

func (s *SstBuf) FindEntryValue(key string, entries []SstEntry) (SstEntry, bool) {
  var entry SstEntry
  var left = 0
  var right = len(entries) - 1

  for left <= right {
    mid := left + int((right - left) / 2)
    //fmt.Println("DEBUG FEV", key, left, right, mid, entries[mid])

    // Found the key
    if entries[mid].Key == key {
      return entries[mid], true
    }

    if entries[mid].Key > key {
      right = mid - 1 // Key would be found before this entry
    } else {
      left = mid + 1 // Key would be found after this entry
    }
  }

  return entry, false
}

func (s *SstBuf) Get(k string) (Value, bool) {
  // Check in-memory buffer
  if latestBufEntry, ok := (*s).findLatestBufferEntryValue(k); ok {
    if latestBufEntry.Deleted {
      return latestBufEntry.Value, false
    } else {
      return latestBufEntry.Value, true
    }
  }

  // Not found, search the sst files
  sstFilenames := (*s).GetSstFilenames()

  // Search in reverse order, newest file to oldest
  for i := len(sstFilenames) - 1; i >= 0; i-- {
    //fmt.Println("DEBUG loading entries from file", sstFilenames[i])
    entries := (*s).LoadEntriesFromSstFile(sstFilenames[i])
    if entry, found := (*s).FindEntryValue(k, entries); found {
      if entry.Deleted {
        return entry.Value, false
      } else {
        return entry.Value, true
      }
    }
  }

  // Key not found
  var val Value
  return val, false
}

func (s *SstBuf) ResetDB() {
  sstFilenames := (*s).GetSstFilenames()
  for _, filename := range sstFilenames {
    os.Remove(filename)
  }
}

