#!/usr/bin/env python
"""
170302  ykim@mz.com

Homework #1
Write a program that prints the numbers from 1 to 100.
For multiples of three print "Fizz" instead of the number.
For multiples of five print "Buzz".
For numbers which are multiples of both three and five print "FizzBuzz".

The expected output should be:
1
2
Fizz
4
Buzz
Fizz
7
8
Fizz
Buzz
11
Fizz
13
14
FizzBuzz
.... and so forth to 100
"""

########################################################################################
import sys

multtab = [ [3, 'Fizz'], [5, 'Buzz'] ]
multlen = len(multtab)

for i in range(1,101):
    found_mult = 0
    for m in range(multlen):
        if i % multtab[m][0] == 0:
            sys.stdout.write('%s' % multtab[m][1])
            found_mult += 1

    if found_mult == 0:
        sys.stdout.write('%s' % i)

    print
