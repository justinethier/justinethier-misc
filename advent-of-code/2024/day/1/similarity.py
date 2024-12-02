l1 = []
l2 = []
#with open("1-input.txt", "r") as file:
with open("input", "r") as file:
  for line in file:
    nums = line.split()
    #print(nums)
    l1.append(int(nums[0]))
    l2.append(int(nums[1]))

l1.sort()
l2.sort()

sim = 0
for x in l1:
  s = l2.count(x) * x
  sim += s
  print(s)

print("score = %d" % sim)
