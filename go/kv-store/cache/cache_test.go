package cache

import (
  "testing"
)

func BenchmarkSeq(b *testing.B) {
  s := NewSequence()

  for i := 0; i < b.N; i++ {
    s.Increment("bench")
    s.Increment("bench 1")
    s.Increment("bench 2")
  }
}

func TestSeq(t *testing.T) {
  if false {
    t.Error("Should never fail")
  }
}
