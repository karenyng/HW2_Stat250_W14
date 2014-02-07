#!/usr/bin/env python 
import os

for i in range(20,24): 
    os.system("(time ./method1.py {0}) 2>> time_cpus.txt".format(i))
