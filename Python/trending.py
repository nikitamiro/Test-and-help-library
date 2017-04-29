import sys
import fileinput
from sys import stdin


#------------Main Call Procedure------------#
number = int(stdin.readline())
arrayInput = [None]*int(number)
trending = None
trendingTopic = False

for i in range(0,len(arrayInput)):
    arrayInput[i] = stdin.readline()
for i in range(0,len(arrayInput)):

	if(len(arrayInput)-i < 60):
		nextIter = len(arrayInput)-i
	else:
		nextIter = 60

	counter = 1
	for j in range(1, nextIter):
		#print arrayInput[i], arrayInput[j+i]
		if(arrayInput[i] == arrayInput[j+i]):
			counter += 1
		#print counter
	
	if counter>=40:
		trendingTopic = True
		print (arrayInput[i])
if trendingTopic == False:
    print ("Pas de trending topic")
