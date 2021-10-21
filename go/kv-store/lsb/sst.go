// TODO: not thread safe!
package lsb

import (
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

