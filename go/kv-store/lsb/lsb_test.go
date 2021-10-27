package lsb

import (
  "bytes"
  "math/rand"
  "strconv"
  "testing"
)

//func BenchmarkSeq(b *testing.B) {
//  for i := 0; i < b.N; i++ {
//    Increment("bench")
//    Increment("bench 1")
//    Increment("bench 2")
//  }
//}

func BenchmarkKeyValue(b *testing.B) {
  ResetDB()

  for i := 0; i < b.N; i++ {
    token := make([]byte, 8)
    rand.Read(token)
    Set(strconv.Itoa(i), Value{Data: token, ContentType: "test content"})
  }

  for i := 0; i < b.N; i++ {
    Get(strconv.Itoa(i))
  }

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
  var N = 100
  ResetDB()

  for i := 0; i < N; i++ {
    // TODO: encode predictable value for i
    //token := make([]byte, 8)
    //rand.Read(token)
    Set(strconv.Itoa(i), Value{Data: []byte(strconv.Itoa(i)), ContentType: "test content"})
  }

  // verify i contains expected value
  for i := 0; i < N; i++ {
    if val, found := Get(strconv.Itoa(i)); found {
      if bytes.Compare(val.Data, []byte(strconv.Itoa(i))) != 0 {
        t.Error("Unexpected value", val.Data, "for key", i)
      }
    } else {
      t.Error("Value not found for key", i)
    }
  }

  for i := 0; i < N; i++ {
    Delete(strconv.Itoa(i))
  }

  // verify key does not exist for i
  for i := 0; i < N; i++ {
    if val, found := Get(strconv.Itoa(i)); found {
      t.Error("Unexpected value", val.Data, "for key", i)
    }
  }


  // TODO: add a key back
  Set("abcd", Value{[]byte("test"), "text"})

  // TODO verify that key exists now
  if val, found := Get("abcd"); found {
    if string(val.Data) != "test" {
      t.Error("Unexpected value", val.Data, "for key", "abcd")
    }
  } else {
    t.Error("Value not found for key", "abcd")
  }
}

func BenchmarkSstKeyValue(b *testing.B) {
  var tbl = NewSstBuf(".", 5000)
  (*tbl).ResetDB()

  for i := 0; i < b.N; i++ {
    token := make([]byte, 8)
    rand.Read(token)
    (*tbl).Set(strconv.Itoa(i), Value{Data: token, ContentType: "test content"})
  }

  for i := 0; i < b.N; i++ {
    (*tbl).Get(strconv.Itoa(i))
  }

  for i := 0; i < b.N; i++ {
    (*tbl).Delete(strconv.Itoa(i))
  }
}

func TestSstInternals(t *testing.T) {
  var tbl = NewSstBuf(".", 25)

  (*tbl).ResetDB()

  (*tbl).Set("test value", Value{[]byte("1"), "text"})
  val, ok := (*tbl).findLatestBufferEntryValue("test value")

  if !ok || bytes.Compare(val.Value.Data, []byte("1")) != 0 {
    t.Error("Unexpected test value", val, ok)
  }
}

func TestSstKeyValue(t *testing.T) {
  var N = 100
  var tbl = NewSstBuf(".", 25)

  (*tbl).ResetDB()

  for i := N - 1; i >= 0; i-- {
    // encode predictable value for i
    (*tbl).Set(strconv.Itoa(i), Value{Data: []byte(strconv.Itoa(i)), ContentType: "test content"})
  }

  (*tbl).Delete(strconv.Itoa(100))
  //(*tbl).Flush()

  // verify i contains expected value
  for i := 0; i < N; i++ {
    if v, found := (*tbl).Get(strconv.Itoa(i)); found {
      if bytes.Compare(v.Data, []byte(strconv.Itoa(i))) != 0 {
        t.Error("Unexpected value", v.Data, "for key", i)
      }
    } else {
      t.Error("Value not found for key", i)
    }
  }

  for i := 0; i < N; i++ {
    (*tbl).Delete(strconv.Itoa(i))
  }

  // verify key does not exist for i
  for i := 0; i < N; i++ {
    if val, found := (*tbl).Get(strconv.Itoa(i)); found {
      t.Error("Unexpected value", val.Data, "for deleted key", i)
    }
  }

  // add a key back
  (*tbl).Set("abcd", Value{[]byte("test"), "text"})

  // verify that key exists now
  if val, found := (*tbl).Get("abcd"); found {
    if string(val.Data) != "test" {
      t.Error("Unexpected value", val.Data, "for key", "abcd")
    }
  } else {
    t.Error("Value not found for key", "abcd")
  }

  (*tbl).Flush()
  // Verify again now that key is on disk
  if val, found := (*tbl).Get("abcd"); found {
    if string(val.Data) != "test" {
      t.Error("Unexpected value", val.Data, "for key", "abcd")
    }
  } else {
    t.Error("Value not found for key", "abcd")
  }
}
