import sys
import fileinput
from sys import stdin


while True:             # Loop continuously
    inp = int(stdin.readline())   # Get the input
    if inp == 2:       # If it is a blank line...
        break    

# while True:             # Loop continuously
#     inp = int(raw_input())   # Get the input
#     if inp == 2:       # If it is a blank line...
#         break   


# while True:
#     try:
#         cash = int(stdin.readline())
#     except (cash>10000):
#         print("1,000 > cash > 10,000.")
#         continue
#     else:
#         break