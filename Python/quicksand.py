import sys
import fileinput
from sys import stdin

#------------Main Call Procedure------------#
W, H = stdin.readline().split()
desert=[]

W = int(W)
H = int(H)

for i in range(0,H):
	desert.append(list(stdin.readline()))
	#desert.append(list(input()))

dist = [[None] * H for i in range(0,W)]
# for i in range(1,H):
# 	for j in range(1,W):
# 		if desert[i,j] == "#":
# 			dist[i,j] = 0

print desert 
print dist


#Isograd Solution

N, M = map(int, input().split())
desert = []
for _ in range(N):
    desert.append(list(input()))
dist = [[0] * M for _ in range(N)]
for i in range(1, N - 1):
    for j in range(1, M - 1):
        dist[i][j] = min(dist[i - 1][j], dist[i][j - 1]) + 1 if desert[i][j] == '#' else 0
for i in range(N - 2, 0, -1):
    for j in range(M - 2, 0, -1):
        if desert[i][j] == '#' and min(dist[i + 1][j], dist[i][j + 1]) + 1 < dist[i][j]:
            dist[i][j] = min(dist[i + 1][j], dist[i][j + 1]) + 1
deepest = 0
for line in dist:
    deepest = max(deepest, max(line))
print(deepest)