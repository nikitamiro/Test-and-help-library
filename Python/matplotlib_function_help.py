# Nikita Miroshnichenko

import mystack
import myteststack
from timeit import Timer
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

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
    a = mystack.MyStack()
    for x in range(i):
        a.push((x - 5) ** 2)

    b = myteststack.MyStack()
    for x in range(i):
        b.push((x - 5) ** 2)

    start_time = time.time()
    a.range()
    range_a_yaxis.append(time.time() - start_time)

    start_time = time.time()
    b.range_built_in()
    range_built_in_b_yaxis.append(time.time() - start_time)

    start_time = time.time()
    b.range_simple()
    range_simple_b_yaxis.append(time.time() - start_time)

    start_time = time.time()
    b.range_pair_comparison()
    range_pair_comparison_b_yaxis.append(time.time() - start_time)

    print("Completed: " + str(i) + " N / " + str(10000) + " N")

# Display performance plot charts
# fig1 = plt.figure(1)
# fig1.canvas.set_window_title('Push Runtime Performance')
# plt.plot()
# a_push_line, = plt.plot(xaxis, push_a_yaxis, 'bo--', label = "mystack push")
# b_push_line, = plt.plot(xaxis, push_b_yaxis, 'ro--', label = "myteststack push")
# plt.legend(handles = [a_push_line, b_push_line])
# plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
#            ncol=2, mode="expand", borderaxespad=0, fontsize='small')
# plt.ylabel("Seconds")
# plt.xlabel("N")
#
# fig2 = plt.figure(2)
# fig2.canvas.set_window_title('Range Runtime Performance')
# plt.plot()
# a_range_line, = plt.plot(xaxis, range_a_yaxis, 'bo--', label = "mystack range")
# b_range_built_in_line, = plt.plot(xaxis, range_built_in_b_yaxis, 'ro--', label = "myteststack range_built_in")
# b_range_simple_line, = plt.plot(xaxis, range_simple_b_yaxis, 'go--', label = "myteststack range_simple")
# b_range_pair_comaprison_line, = plt.plot(xaxis, range_pair_comparison_b_yaxis, 'yo--',
#                                          label = "myteststack range_pair_comaprison")
# plt.legend(handles = [a_range_line, b_range_built_in_line, b_range_simple_line, b_range_pair_comaprison_line])
# plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
#            ncol=2, mode="expand", borderaxespad=0, fontsize='small')
# plt.ylabel("Seconds")
# plt.xlabel("N")
#
# plt.show()

# fig1 = plt.figure(1)
# fig1.canvas.set_window_title('Push Runtime Performance')

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