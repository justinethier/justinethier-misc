package lsb

import (
  "math/rand"
  "strconv"
  "testing"
)

// TODO: comparable tests to cache package
//func BenchmarkSeq(b *testing.B) {
//  s := NewSequence()
//
//  for i := 0; i < b.N; i++ {
//    s.Increment("bench")
//    s.Increment("bench 1")
//    s.Increment("bench 2")
//  }
//}

func BenchmarkKeyValue(b *testing.B) {
  //m := NewMap()

  ResetDB()

  for i := 0; i < b.N; i++ {
    token := make([]byte, 8)
    rand.Read(token)
    Set(strconv.Itoa(i), Value{Data: token, ContentType: "test content"})
  }

  //for i := 0; i < b.N; i++ {
  //  m.Get(strconv.Itoa(i))
  //}

  for i := 0; i < b.N; i++ {
    Delete(strconv.Itoa(i))
  }
}

func TestSeq(t *testing.T) {
  if false {
    t.Error("Should never fail")
  }
}

func TestKeyValue(t *testing.T) {
  ResetDB()

  for i := 0; i < b.N; i++ {
    // TODO: encode predictable value for i
    token := make([]byte, 8)
    rand.Read(token)
    Set(strconv.Itoa(i), Value{Data: token, ContentType: "test content"})
  }

  // TODO: verify i contains expected value
  //for i := 0; i < b.N; i++ {
  //  m.Get(strconv.Itoa(i))
  //}

  for i := 0; i < b.N; i++ {
    Delete(strconv.Itoa(i))
  }

  // TODO: verify key does not exist for i
  //for i := 0; i < b.N; i++ {
  //  m.Get(strconv.Itoa(i))
  //}


  // TODO: add a key back
  // TODO verify that key exists now
}
