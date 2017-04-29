import sys
import fileinput
from sys import stdin

class mainClass(object):

	def __init__(self, arrayVar):
		self.arrayVar = arrayVar

		self.Proc1Var = 0
		self.Proc2Var = 0

	def Proc1(self):

		for i in range(0,len(self.arrayVar)-1):
			if(self.arrayVar[i]>self.arrayVar[i+1]):
				self.Proc1Var += self.arrayVar[i]-self.arrayVar[i+1]

	def Proc2(self):

		rate = 0
		for i in range(0,len(self.arrayVar)-1):
			if(self.arrayVar[i]-self.arrayVar[i+1])>rate:
				rate=self.arrayVar[i]-self.arrayVar[i+1]

		for i in range(0,len(self.arrayVar)-1):
			if(self.arrayVar[i] > rate):
				self.Proc2Var+=rate
			else:
				self.Proc2Var+=self.arrayVar[i]

#------------Main Call Procedure------------#
x = stdin.readline()
arrayInput=[None]*int(x)*2

for i in range(0,len(arrayInput)):
	arrayInput[i] = stdin.readline()

testCase=1
for i in range(1,len(arrayInput)+1,2):
	testObj=mainClass(map(int, arrayInput[i].split()))
	testObj.Proc1()
	testObj.Proc2()

	print "Case #", testCase," ",testObj.Proc1Var," ",testObj.Proc2Var
	testCase+=1

#------------Sample input and output------------#
# Nikitas-MacBook-Air:Desktop alexeyevich$ python mushroom.py
# 4
# 4
# 10 5 15 5
# 2
# 100 100
# 8
# 81 81 81 81 81 81 81 0
# 6
# 23 90 40 0 100 9
# Case # 1   15   25
# Case # 2   0   0
# Case # 3   81   567
# Case # 4   181   244
# Nikitas-MacBook-Air:Desktop alexeyevich$ 