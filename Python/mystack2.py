# Nikita Miroshnichenko


class StackInputError(Exception):
    def __init_(self):
        super().__init_("Error: push input should be an integer")


class StackEmptyError(Exception):
    def __init_(self):
        super().__init_("Error: stack is empty")


class MyStack:
    def __init__(self):
        self.stack = []
        self.min_stack = []
        self.max_stack = []

    def size(self):
        return len(self.stack)

    def is_empty(self):
        return self.stack == []

    def push(self, value):
        """When a new item is pushed, it's compared to the peeks of the min and max stack.
        If the new item is the new min or max, then it is also pushed onto the min or max stack respectively.
        If the new item is equal to the current min or max, then it is still pushed onto the min or max stack
        respectively.
        """
        if not isinstance(value, int):
            raise StackInputError()
        self.stack.append(value)

        # Update the min and max stack
        if len(self.stack) == 1:
            self.min_stack.append(value)
            self.max_stack.append(value)
        else:
            if value <= self.min_stack[(len(self.min_stack) - 1)]:
                self.min_stack.append(value)
            elif value >= self.max_stack[(len(self.max_stack) - 1)]:
                self.max_stack.append(value)

    def pop(self):
        """When an item is popped, it's compared to the peeks of the min and max stack.
        If the popped item is the current min or max, then it is also popped from the min or max stack respectively.
        """

        if not self.stack:
            raise StackEmptyError()

        popped = self.stack.pop()

        # Update the min and max stack
        if popped == self.min_stack[(len(self.min_stack) - 1)]:
            self.min_stack.pop()
        if popped == self.max_stack[(len(self.max_stack) - 1)]:
            self.max_stack.pop()

        return popped

    def peek(self):
        if not self.stack:
            raise StackEmptyError()
        return self.stack[(len(self.stack) - 1)]

    def flush(self):
        self.stack = []

    def range(self):
        """Returns the stack range (the peeks of the min and max stacks). O(1) runtime.
        This is faster than an O(N) range function that will iteratively look for the min and max of a list.
        """

        if not self.stack:
            raise StackEmptyError()
        return self.min_stack[(len(self.min_stack) - 1)], self.max_stack[(len(self.max_stack) - 1)]

# --------------------------------------------------------------------------------------------------------------------------------
# testing mystack


# Nikita Miroshnichenko

import mystack
import myteststack
from timeit import Timer
import matplotlib.pyplot as plt
import time

a = mystack.MyStack()
b = myteststack.MyStack()

# Display help comments on range functions from mystack and myteststack
print("----------\n")
print(help(a.range))
print("----------\n")
print(help(b.range_pair_comparison))
print(help(b.range_built_in))
print(help(b.range_simple))
print("----------\n")

push_a_yaxis = []
push_b_yaxis = []

range_a_yaxis = []
range_built_in_b_yaxis = []
range_simple_b_yaxis = []
range_pair_comparison_b_yaxis = []

xaxis = []

for i in range(100, 10100, 100):
    xaxis.append(i)

    # Fill in y axis for push runtimes
    a_time = Timer("""for x in range(""" + str(i) + """): a.push((x - 5) ** 2)""",
                   setup = """import mystack; a = mystack.MyStack()""")
    push_a_yaxis.append(a_time.timeit(10) / 10)

    b_time = Timer("""for x in range(""" + str(i) + """): b.push((x - 5) ** 2)""",
                   setup = """import myteststack; b = myteststack.MyStack()""")
    push_b_yaxis.append(b_time.timeit(10) / 10)

    # Fill in y axis for range lookup runtimes
    # Using time lib instead of timeit because of restrictions on having compound timeit setup statements
    # Will run each range function 10 times, time the runs and take the average
    a = mystack.MyStack()
    for x in range(i):
        a.push((x - 5) ** 2)

    b = myteststack.MyStack()
    for x in range(i):
        b.push((x - 5) ** 2)

    range_a_average = 0
    range_built_in_b_average = 0
    range_simple_b_average = 0
    range_pair_comparison_b_average = 0

    for j in range(0, 10):
        start_time = time.time()
        a.range()
        range_a_average += time.time() - start_time

        start_time = time.time()
        b.range_built_in()
        range_built_in_b_average += time.time() - start_time

        start_time = time.time()
        b.range_simple()
        range_simple_b_average += time.time() - start_time

        start_time = time.time()
        b.range_pair_comparison()
        range_pair_comparison_b_average += time.time() - start_time

    range_a_yaxis.append(range_a_average / 10)
    range_built_in_b_yaxis.append(range_built_in_b_average / 10)
    range_simple_b_yaxis.append(range_simple_b_average / 10)
    range_pair_comparison_b_yaxis.append(range_pair_comparison_b_average / 10)

    print("Completed: " + str(i) + " N / " + str(10000) + " N")

# Display performance plot charts
plt.close('all')
fig = plt.figure()

plt.subplot(2, 1, 1)
a_push_line, = plt.plot(xaxis, push_a_yaxis, 'bo--', label = "mystack push")
b_push_line, = plt.plot(xaxis, push_b_yaxis, 'ro--', label = "myteststack push")
plt.legend(handles = [a_push_line, b_push_line])
plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
           ncol=2, borderaxespad=0, fontsize='12')
plt.ylabel("Seconds")
plt.xlabel("N")

plt.subplot(2, 1, 2)
a_range_line, = plt.plot(xaxis, range_a_yaxis, 'bo--', label = "mystack range")
b_range_built_in_line, = plt.plot(xaxis, range_built_in_b_yaxis, 'ro--', label = "myteststack range_built_in")
b_range_simple_line, = plt.plot(xaxis, range_simple_b_yaxis, 'go--', label = "myteststack range_simple")
b_range_pair_comaprison_line, = plt.plot(xaxis, range_pair_comparison_b_yaxis, 'yo--',
                                         label = "myteststack range_pair_comaprison")
plt.legend(handles = [a_range_line, b_range_built_in_line, b_range_simple_line, b_range_pair_comaprison_line])
plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
           ncol=2, borderaxespad=0, fontsize='12')
plt.ylabel("Seconds")
plt.xlabel("N")

plt.subplots_adjust(hspace=.6)
fig.canvas.set_window_title('Push and Range Runtime Performance')
plt.show()
