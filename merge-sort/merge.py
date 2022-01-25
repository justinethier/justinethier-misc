import math

def merge_sort(lis):
  if len(lis) == 1:
    return lis
  mid = math.floor(len(lis) / 2)
  a = merge_sort(lis[:mid])
  b = merge_sort(lis[mid:])
  return merge(a, b)

def merge(x, y):
  i = 0
  j = 0 
  xx = len(x)
  yy = len(y)
  lis = []
  while i < xx or j < yy:
    #print(i, j, lis)
    if j < yy and (i == xx or x[i] > y[j]):
      lis.append(y[j])
      j += 1
    else:
      lis.append(x[i])
      i += 1
  return lis

#print(merge_sort
