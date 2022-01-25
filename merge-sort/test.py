#!/usr/bin/python3
import merge
import random
import unittest

class Tests(unittest.TestCase):
  def test_merge(self):
    self.assertEqual(merge.merge([1, 2, 3], [4, 5, 6]), [1, 2, 3, 4, 5, 6])
    self.assertEqual(merge.merge([1, 4, 6], [2, 3, 5]), [1, 2, 3, 4, 5, 6])
    self.assertEqual(merge.merge([2, 4, 6], [1, 3, 5]), [1, 2, 3, 4, 5, 6])
    self.assertEqual(merge.merge([4, 5, 6], [1, 2, 3]), [1, 2, 3, 4, 5, 6])

  def test_chaos_monkey(self):
    for i in range(1000):
      lis = [random.random() for _ in range(100)]
      merged = merge.merge_sort(lis)
      lis.sort()
      self.assertEqual(lis, merged)

if __name__ == '__main__':
  unittest.main()
