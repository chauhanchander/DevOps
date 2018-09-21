#!/usr/bin/env python
import pdb

print ("Tuple Assignment")

a = (1, 2)
b = (3, 4)

c = (5, 6)
d = (7, 8)
print (a)
print (b)

(a, b) = (c, d)

print ("After assignment")

print (c)
print (d)
print ("Unpacking")

e, f = c

print (e)
print (f)
container = [2, 5, 6, 9, 8]

product = reduce((lambda x, y: x * y), container) 

print (product)
print ("Reduce function complete")
number_list = range(-5, 5)

less_than_zero = list(filter(lambda x: x < 0, number_list))

print (less_than_zero)

alist = [ 'a', 'b', 'c', 'd', 'c', 'e', 'f', 'f', 'g' ]

list_duplicates = set([x for x in alist if alist.count(x) > 1])

print (list_duplicates)
print ("The first duplicate is", list_duplicates[0])


squared = []

for i in container:
    squared.append(i**2)
# or
squared = list(map(lambda x: x**2, container))

print (squared)
for item in container:
    if item == 0 :
        pdb.set_trace()
        print ("found it")
        break
else:
    print ("not found in container")

for n in range(2, 10):
    for x in range(2, n):
        print(x,n)
        if n % x == 0:
            print (x)
            print(n, 'equals')
            break
else:
    print(n, 'is a prime number')
