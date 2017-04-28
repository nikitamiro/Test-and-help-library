import math
import numpy as np
line_sep_main = "# --------------------------------------------------------------------------------------------------------------------------------"


# --------------------------------------------------------------------------------------------------------------------------------
# list index and variables
print("\nlist index and variables"+line_sep_main)


xtest_list = [1, "dog", 3.5, "lilian"]

for index, item in enumerate(xtest_list):
    print("#%d %s" % (index, item))


# --------------------------------------------------------------------------------------------------------------------------------
# string to character array
print("\nstring to character array"+line_sep_main)

s = "mystring"
l = list(s)

# ascii array
a = [ord(x) for x in l]

print(l)
print(a)



# --------------------------------------------------------------------------------------------------------------------------------
#Insert value at top of list
var=7
array = [1,2,3,4,5,6]
array.insert(0,var)
array
#[7, 1, 2, 3, 4, 5, 6]

# --------------------------------------------------------------------------------------------------------------------------------
# load text into numpy array
values = np.loadtxt('data', delimiter=',', usecols=[0,1,2,3])
labels = np.loadtxt('data', delimiter=',', usecols=[4])

# --------------------------------------------------------------------------------------------------------------------------------
# read command line

import sys
arg1 = sys.argv[1]
arg2 = sys.argv[2]


# --------------------------------------------------------------------------------------------------------------------------------
# read into matrix and then get sharpe ratio
print("\nread into matrix and then get sharpe ratio"+line_sep_main)

# func to get index in list
def in_list(search_item, m):
    for i in m:
        if search_item in i:
            return m.index(i)
    return -1

# read all lines from file into l matrix
file_var = open('assets/trade.csv', 'r')
lines = file_var.readlines()[1:] # ignore header title
matrix = [list(map(float, line.rstrip().split(','))) for line in lines]
print(matrix)

# check that first row can be read
print("Printing 1st row")
print(matrix[1])

# get sharpe ratio
start = 20160107.0
end = 20160118.0

# iterate from start to end
start_index = in_list(start,matrix)
end_index = in_list(end,matrix)

count_val = sum_val = sum_val_sqrd=0

for row in matrix[start_index:end_index+1]:
    count_val += 1
    sum_val += row[4] - row[5]
    sum_val_sqrd += (row[4] - row[5])**2

# get sharpe ratio
sr = (sum_val/count_val)/math.sqrt((sum_val_sqrd/count_val)-(sum_val/count_val)**2)
print(sr)

# --------------------------------------------------------------------------------------------------------------------------------
# read line by line and calc sharpe ratio
print("\nread line by line and calc sharpe ratio"+line_sep_main)

# use simple sharpe ratio lambda expression
sharpe_ratio = lambda count, sum, sumsq: (sum/count)/math.sqrt((sumsq/count)-(sum/count)**2)

file_var = open('assets/trade.csv', 'r')
lines = file_var.readlines()[1:]

# get sharpe ratio
start = 20160107.0
end = 20160118.0

count_val = sum_val = sum_val_sqrd = 0
for line in lines:
    temp_arr = line.rstrip().split(',')

    if float(temp_arr[0]) <= end and float(temp_arr[0]) >= start:
        count_val += 1
        sum_val += float(temp_arr[4]) - float(temp_arr[5])
        sum_val_sqrd += (float(temp_arr[4]) - float(temp_arr[5]))**2

# get sharpe ratio
sr = (sum_val/count_val)/math.sqrt((sum_val_sqrd/count_val)-(sum_val/count_val)**2)
print(sr)

# calcs the same thing, but using the lambda function
print(sharpe_ratio(count_val, sum_val, sum_val_sqrd))

# --------------------------------------------------------------------------------------------------------------------------------
# Hash table
print("\nHash table"+line_sep_main)

class MyHash():

    def __init__(self):
        self.size = 10
        self.hash = [[] for x in range(self.size)]

    def hash_function(self, key):
        return key % self.size

    def hash_insert(self, key, value):
        self.hash[self.hash_function(key)].append((key, value))

    def return_value(self, key):
        for x in a.hash[a.hash_function(key)]:
            if x[0] == key:
                return x[1]

a = MyHash()
a.hash_insert(10, "apple")
a.hash_insert(20, "lemon")
a.hash_insert(13, "banana")
a.hash_insert(40, "orange")
a.hash_insert(23, "tangerine")
a.hash_insert(93, "pineapple")

print(a.hash)

print(a.return_value(23))
print(a.return_value(40))


# --------------------------------------------------------------------------------------------------------------------------------
# Hash tables = Dictionary in Python
print("\nHash tables = Dictionary in Python"+line_sep_main)

keys = ['a', 'b', 'c']
values = [1, 2, 3]
dict = {k:v for k, v in zip(keys, values)}
print(dict)

print(dict['a'])
dict['a'] = 10
print(dict['a'])

# 3 lists (1 key list, 2 value lists)
keys = ['a', 'b', 'c']
values_1 = [1, 2, 3]
values_2 = [13, 27, 78]
dict = {k:v for k, v in zip(keys, zip(values_1, values_2))}
print(dict)

# 3 lists (1 key list, 3 value lists (1 list for each value))
keys = ['a', 'b', 'c']
values_1 = [1, 2, 3]
values_2 = [13, 27, 78]
values_3 = ["nikita", "lilian", "dog"]
dict = {k:v for k, v in zip(keys, (values_1, values_2, values_3))}
print(dict)

# --------------------------------------------------------------------------------------------------------------------------------
# Queue
# constant time for enqueue
print("\nQueue: constant time for enqueue"+line_sep_main)

class MyNode():

    def __init__(self, data):
        self.data = data
        self.next = None

class MyQueue():

    def __init__(self):
        self.first = None
        self.last = None
        self.size_val = 0

    def enqueue(self, data):
        new_node = MyNode(data)
        if (self.last is not None):
            self.last.next = new_node
        self.last = new_node
        if (self.first is None):
            self.first = self.last
        # calc the size
        self.size_val += 1

    def dequeue(self):
        if (self.first is None): raise LookupError("Queue is empty")
        return_value = self.first.data
        self.first = self.first.next
        if(self.first is None):
            self.last is None

        # calc the size
        self.size_val -= 1

        return return_value

    def peek(self):
        if (self.first is None): raise LookupError("Queue is empty")
        return self.first.data

    def is_empty(self):
        return self.first.data is None

    def size_iterative(self):
        if(self.first.data is None): return 0
        x = self.first
        size = 1

        while(x.next is not None):
            x = x.next
            size += 1
        return size

q = MyQueue()
q.enqueue(4)
q.enqueue('dog')
q.enqueue(True)
print(q.size_iterative())
print(q.size_val)
print(q.is_empty())
q.enqueue(8.4)
print(q.dequeue())
print(q.dequeue())
print(q.size_iterative())
print(q.size_val)

# --------------------------------------------------------------------------------------------------------------------------------
# Queue - quick code
# Not constant time for enqueue
print("\nQueue - quick code: Not constant time for enqueue"+line_sep_main)

class MyOtherNode():

    def __init__(self, cargo):
        self.cargo = cargo
        self.next = None

class MyOtherQueue:
    def __init__(self):
        self.length = 0
        self.head = None

    def is_empty(self):
        return self.length == 0

    def enqueue(self, cargo):
        node = MyOtherNode(cargo)
        if self.head is None:
            # If list is empty the new node goes first
            self.head = node
        else:
            # Find the last node in the list
            last = self.head
            while last.next:
                last = last.next
            # Append the new node
            last.next = node
        self.length += 1

    def dequeue(self):
        cargo = self.head.cargo
        self.head = self.head.next
        self.length -= 1
        return cargo

q = MyOtherQueue()
q.enqueue(4)
q.enqueue('dog')
q.enqueue(True)
print(q.is_empty())
q.enqueue(8.4)
print(q.dequeue())
print(q.dequeue())

# --------------------------------------------------------------------------------------------------------------------------------
# Priority Queue
print("\nPriority Queue"+line_sep_main)


class MyPriorityQueue:
    def __init__(self):
        self.items = []

    def is_empty(self):
        return not self.items

    def insert(self, item):
        self.items.append(item)

    def remove(self):
        maxi = 0
        for i in range(1, len(self.items)):
            if self.items[i] > self.items[maxi]:
                maxi = i
        item = self.items[maxi]
        del self.items[maxi]
        return item

q = MyPriorityQueue()
for num in [11, 12, 14, 13]:
    q.insert(num)

while not q.is_empty():
    print(q.remove())


print("Testing golfer on priority queue. Overide __gt__ method so that less is more, because it's golf.")
# Add Golfer class that implements priority queue in opposite direction. o
# override __gt__ (greater than to be; so less is more)

class Golfer:
    def __init__(self, name, score):
        self.name = name
        self.score= score

    def __str__(self):
        return "{0:16}: {1}".format(self.name, self.score)

    def __gt__(self, other):
        return self.score < other.score  # Less is more

tiger = Golfer("Tiger Woods", 61)
phil = Golfer("Phil Mickelson", 72)
hal = Golfer("Hal Sutton", 69)

pq = MyPriorityQueue()
for golfer in [tiger, phil, hal]:
    pq.insert(golfer)

while not pq.is_empty():
    print(pq.remove())

# --------------------------------------------------------------------------------------------------------------------------------
# Singly-linked list
print("\nSingly-linked list"+line_sep_main)


class Node(object):
    def __init__(self, data, next):
        self.data = data
        self.next = next

class SingleList(object):
    head = None
    tail = None

    def show(self):
        print("Showing list data:")
        current_node = self.head
        while current_node is not None:
            print(current_node.data, " -> ",)
            current_node = current_node.next
        print(None)

    def append(self, data):
        node = Node(data, None)
        if self.head is None:
            self.head = self.tail = node
        else:
            self.tail.next = node
        self.tail = node

    def remove(self, node_value):
        current_node = self.head
        previous_node = None
        while current_node is not None:
            if current_node.data == node_value:
                # if this is the first node (head)
                if previous_node is not None:
                    previous_node.next = current_node.next
                else:
                    self.head = current_node.next

            # needed for the next iteration
            previous_node = current_node
            current_node = current_node.next

s = SingleList()
s.append(31)
s.append(2)
s.append(3)
s.append(4)

s.show()
s.remove(31)
s.remove(3)
s.remove(2)
s.show()

# --------------------------------------------------------------------------------------------------------------------------------
# Doubly-linked list:  DON'T need to go through whole list like the [def remove] does!
# in doubly-linked list can just take the prev and next of the 'to be deleted' node and update their next and prev!
# in doubly linked list: remove can be constant time, and can traverse backwards.
print("\nDoubly-linked list"+line_sep_main)


class Node(object):
    def __init__(self, data, prev, next):
        self.data = data
        self.prev = prev
        self.next = next


class DoubleList(object):
    head = None
    tail = None

    def append(self, data):
        new_node = Node(data, None, None)
        if self.head is None:
            self.head = self.tail = new_node
        else:
            new_node.prev = self.tail
            new_node.next = None
            self.tail.next = new_node
            self.tail = new_node

    def remove(self, node_value):
        current_node = self.head

        while current_node is not None:
            if current_node.data == node_value:
                # if it's not the first element
                if current_node.prev is not None:
                    current_node.prev.next = current_node.next
                    current_node.next.prev = current_node.prev
                else:
                    # otherwise we have no prev (it's None), head is the next one, and prev becomes None
                    self.head = current_node.next
                    current_node.next.prev = None

            current_node = current_node.next

    def show(self):
        print("Show list data:")
        current_node = self.head
        while current_node is not None:
            print(current_node.prev.data if hasattr(current_node.prev, "data") else None,
            current_node.data,
            current_node.next.data if hasattr(current_node.next, "data") else None)

            current_node = current_node.next
        print("*" * 50)


d = DoubleList()

d.append(5)
d.append(6)
d.append(50)
d.append(30)

d.show()

d.remove(50)
d.remove(5)

d.show()


# --------------------------------------------------------------------------------------------------------------------------------
# test
print("\ntest"+line_sep_main)