l1 = []
l2 = []
with open("1-input.txt", "r") as file:
  for line in file:
    nums = line.split()
    #print(nums)
    l1.append(int(nums[0]))
    l2.append(int(nums[1]))

l1.sort()
l2.sort()

sum = 0
for x, y in zip(l1, l2):
  dist = abs(x - y)
  sum += dist
  print(dist)

print("sum = %d" % sum)
