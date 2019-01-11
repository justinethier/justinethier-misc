#!/usr/bin/python
import fileinput

def getKey(line):
  ps = line.split(" ")
  if len(ps[1]) == 0:
    key = ps[0] + " " + ps[2] + " " + ps[3]
  else:
    key = ps[0] + " " + ps[1] + " " + ps[2]
  return key #[:-3] # By minute, not second

lines = [ \
           "Jul 22 02:51:37 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:51:37 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:51:37 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:51:51 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:52:36 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:52:51 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:52:57 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:52:59 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:53:36 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" \
         , "Jul 22 02:53:44 gateway acbacs: Discovery Error: APDU Timeout for 1 after waiting 10 second" ]

fp = open("data.txt", "r")
lines = fp.readlines()

key = None
nKey = None
count = 0
for l in lines:
#for l in fileinput.input():
  nKey = getKey(l)
  if key is None:
    count = count + 1
    key = nKey
  elif key == nKey:
    count = count + 1
  else:
    print("%s, %d" % (key, count))
    count = 1
    key = nKey

print("%s, %d" % (nKey, count  ))

