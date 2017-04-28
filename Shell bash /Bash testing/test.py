import sys

print(sys.argv[0])
#for line in sys.stdin:
#    print line

a=13
b=20
print (str(b) + " mod " + str(a) + " is " + str(b%a) + " .test is done")
print ("%d mod %d is %d. Test is done" % (b, a, b%a))

# test out lambda function

x=13565 # let's get the mod 56
y = lambda x: x % 56

print(y(x))

