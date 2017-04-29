import sys
import fileinput
from sys import stdin

#------------Main Call Procedure------------#
number = int(stdin.readline())
arrayInput = [None]*int(number)

MMarr = []
FFarr = []
MFarr = []
FMarr = []

extensionCord = 0 
# To make longest cord add F-M and M-F together. Because F-M = M-F and vice versa. So you get F-M + F-M + F-M etc.
# Count how many M-M and F-F there are and add the min amount. So it gives you F-F + M-M = F-M which is F-M = M-F 
# and so add to make cord, and vice versa.

for i in range(0,number):
    gender, lengthVar = stdin.readline().split()

    if gender =="M-M":
    	MMarr.append(int(lengthVar))
    elif gender =="F-F":
    	FFarr.append(int(lengthVar))
    elif gender =="F-M":
    	FMarr.append(int(lengthVar))
    elif gender =="M-F":
    	MFarr.append(int(lengthVar))

extensionCord += sum(MFarr) + sum(FMarr)
MMarr.sort(reverse=True)
FFarr.sort(reverse=True)
mmLen = len(MMarr)
ffLen = len(FFarr)

if mmLen <= ffLen:
	extensionCord += sum(MMarr) + sum(FFarr[:mmLen])
else:
	extensionCord += sum(MMarr[:ffLen]) + sum(FFarr)

print (extensionCord)



