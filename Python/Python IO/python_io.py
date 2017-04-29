import math
#---------------------------------------------------------------------
#read into matrix and then get sharpe ratio

#func to get index in list
def in_list(item,L):
    for i in L:
        if item in i:
            return L.index(i)
    return -1

#read all lines from file into l matrix
file_var = open ( 'trade.csv' , 'r')
lines = file_var.readlines()[1:] #ignore header title
matrix = [ map(float,line.rstrip().split(',')) for line in lines]
print matrix

#check that first row can be read
print("Printing 1st row")
print matrix[1]

#get charpe ratio
start = 20160107.0
end = 20160118.0

#iterate from start to end
start_index = in_list(start,matrix)
end_index = in_list(end,matrix)

count_val = sum_val = sum_val_sqrd=0

for row in matrix[start_index:end_index+1]:
	count_val+= 1
	sum_val+= row[4] - row[5]
	sum_val_sqrd+=(row[4] - row[5])**2

#get sharpe ratio
sr = (sum_val/count_val)/math.sqrt((sum_val_sqrd/count_val)-(sum_val/count_val)**2)
print(sr)
#---------------------------------------------------------------------
#read line by line and calc sharpe ratio

# use simple sharpe ratio lambda expression
sharpe_ratio = lambda count, sum, sumsq: (sum/count)/math.sqrt((sumsq/count)-(sum/count)**2)

file_var = open ( 'trade.csv' , 'r')
lines = file_var.readlines()[1:] 

#get charpe ratio
start = 20160107.0
end = 20160118.0

count_val = sum_val = sum_val_sqrd=0
for line in lines:
	temp_arr = line.rstrip().split(',')

	if ((float(temp_arr[0])<=end) and (float(temp_arr[0])>=start)):
		count_val+= 1
		sum_val+= float(temp_arr[4]) - float(temp_arr[5])
		sum_val_sqrd+= (float(temp_arr[4]) - float(temp_arr[5]))**2

#get sharpe ratio
sr = (sum_val/count_val)/math.sqrt((sum_val_sqrd/count_val)-(sum_val/count_val)**2)
print(sr)

print(sharpe_ratio(count_val, sum_val, sum_val_sqrd))

