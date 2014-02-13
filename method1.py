#!/usr/bin/env python
from __future__ import division
import numpy as np
import pp
import sys

data_path = "./data/"
max_cpus = 24
fileno = 81

# catch exception
assert len(sys.argv) == 2, "Requires user to specify number of cpu " + \
    "used for parallelization"
assert int(sys.argv[1]) <= max_cpus, "Max number of cpu used = 24" + \
    " problematic input = ".format(sys.argv[0])

# have the job server use the specified number of CPU!
ncpus = int(sys.argv[1])


def kludgy_read_csv_wrapper1(files):
    import pandas as pd
    import numpy as np
    return np.array(pd.read_csv(files, usecols=["ArrDelay"]))


def kludgy_read_csv_wrapper2(files):
    import numpy as np
    import pandas as pd
    return np.array(pd.read_csv(files, usecols=["ARR_DELAY"]))


def start_batches1(batches, yr_batch):
    '''
    inputs:
    batches list
        for holding the jobs
    yr_batch list
        for holding the filenames of this batch of jobs
    '''
    print "starting batch {0}".format(batch)
    print "year batch = ", yr_batch
    jobs1 = [(input1,
              job_server.submit(kludgy_read_csv_wrapper1,
                                (input1,))) for input1 in yr_batch]
    # wait til this batch is finished first
    print "wait for it ..."
    job_server.wait()
    batches.append(jobs1)


def start_batches2(batches, mth_batch):
    ''' start jobs with kludgy_read_csv_wrapper 2
    should try combining start_batches functions

    inputs:
    batches list
        for holding the jobs
    mth_batch list
        for holding the filenames of this batch of jobs
    '''
    print "starting batch {0}".format(batch)
    print "mth batch = ", mth_batch
    jobs1 = [(input1,
              job_server.submit(kludgy_read_csv_wrapper2,
                                (input1,))) for input1 in mth_batch]
    # wait til this batch is finished first
    print "wait for it ..."
    job_server.wait()
    batches.append(jobs1)


# initialize list of filenames to be used
#yr_by_yr_files = [data_path + "1987.csv"]
yr_by_yr_files = [data_path + str(i) + ".csv" for i in range(1987, 2008)]
month = ["January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November",
         "December"]
mnth_by_mnth_files = \
    [data_path + str(yr) + "_" + mnth +
     ".csv" for yr in range(2008, 2013) for mnth in month]

##print "going to read in the following # of files:" + \
##    " {0}".format(len(yr_by_yr_files) + len(mnth_by_mnth_files))

# only launch a batch of multiprocess matchin # of cpu at same time
# let numbatch = required numbatch - 1
# let lastbatchsize tell what the remaining matchsize should be
batchsize = ncpus
yr_numbatch = int(np.floor(len(yr_by_yr_files) / ncpus))
lastyrbatchsize = yr_numbatch % ncpus

mth_numbatch = int(np.floor(len(mnth_by_mnth_files) / ncpus))
lastmnthbatchsize = mth_numbatch % ncpus

# calculate how many batches in total is needed
if lastyrbatchsize > 0:
    print "adding last yr batch"
    yr_numbatch += 1
if lastmnthbatchsize > 0:
    print "adding last mth batch"
    mth_numbatch += 1

# initialize a list to store all the batches
batches = []

# start job_server matching number of cores
job_server = pp.Server(ncpus=ncpus)

# looping in python
for batch in range(yr_numbatch):
    if batch != yr_numbatch - 1:
        # subset the appropriate files to be input
        yr_batch = yr_by_yr_files[batch * batchsize: (batch + 1) *
                                  batchsize]
        start_batches1(batches, yr_batch)
    else:
        if lastyrbatchsize > 0:
            yr_batch = yr_by_yr_files[batch * batchsize: batch *
                                      batchsize + lastyrbatchsize]
            start_batches1(batches, yr_batch)

for batch in range(mth_numbatch):
    if batch != mth_numbatch - 1:
        # subset the appropriate files to be input
        mth_batch = mnth_by_mnth_files[batch * batchsize: (batch + 1) *
                                       batchsize]
        start_batches2(batches, mth_batch)
    else:
        if lastmnthbatchsize > 0:
            mth_batch = mnth_by_mnth_files[batch * batchsize: batch *
                                           batchsize + lastmnthbatchsize]
            start_batches2(batches, mth_batch)


delay = np.array([])
for batch in range(yr_numbatch):
    thisbatch = batches[batch]
    #print "this batch is ", thisbatch, "\n"
    for input1, job1 in thisbatch:
        delay = np.append(delay, job1())

for batch in range(yr_numbatch, yr_numbatch + mth_numbatch - 1):
    thisbatch = batches[batch]
    #print "this batch is ", thisbatch, "\n"
    for input1, job1 in thisbatch:
        delay = np.append(delay, job1())

print delay.size

## one can parallelize the following but it's not worth the overhead
delay = delay[~np.isnan(delay)]
mean = np.mean(delay)
sd = np.std(delay)
median = np.median(delay)
#print "number of valid lines {0}".format(delay.size())

f = open("pp_{0}.txt".format(ncpus), "w")
f.write('mean = {0:1.7}\n'.format(mean))
f.write('median = {0:1.7}\n'.format(median))
f.write('std = {0:1.7}\n'.format(sd))
f.close()
