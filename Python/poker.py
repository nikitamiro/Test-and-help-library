import sys
import fileinput
from sys import stdin


#------------Main Call Procedure------------#

#-- Solution 1
cash = int(stdin.readline())
hands = stdin.readline()

arrayInput = [None]*int(hands)

for i in range(0,int(hands)):
    temp = stdin.readline()
    X, Y = temp.split()
    cash = cash-int(X)+int(Y)
print (cash)

#-- Solution 3
# while True:             
#     cash = int(stdin.readline())   
#     if (cash>=1000) and (cash<=10000):       
#         break  
#     print("1,000 > cash > 10,000.")
# while True:             
#     hands = int(stdin.readline())   
#     if (hands>=10) and (hands<=45):       
#         break
#     print("10 > cash > 45.")

# lines = []
# for i in range(0,int(hands)):
#   lines.append(stdin.readline())

# for i in range(0,len(lines)):
#     X = int(lines[i].split(' ')[0])
#     Y = int(lines[i].split(' ')[1])
#     cash = cash-int(X)+int(Y)
# print (cash)

#-- Solution 2
# lines = []
# for line in sys.stdin:
#     lines.append(line.rstrip('\n'))
# cash = int(lines[0])
# hands = int(lines[1])

# for i in range(2,2+int(hands)):
#     X = int(lines[i].split(' ')[0])
#     Y = int(lines[i].split(' ')[1])
#     cash = cash-int(X)+int(Y)
# print (cash)




