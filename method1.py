#!/usr/bin/env python
import numpy as np
import pp
import sys

data_path = "../data/"
max_cpus = 24

# catch exception
assert len(sys.argv) == 2, "Requires user to specify number of cpu " + \
    "used for parallelization"
assert int(sys.argv[1]) <= max_cpus, "Max number of cpu used = 24" + \
		" problematic input = ".format(argsv[0])

# have the job server use the specified number of CPU!
ncpus = int(sys.argv[1])
job_server = pp.Server(ncpus=ncpus)


def kludgy_read_csv_wrapper1(files):
    import pandas as pd
    import numpy as np
    return np.array(pd.read_csv(files, usecols=["ArrDelay"]))


def kludgy_read_csv_wrapper2(files):
    import numpy as np
    import pandas as pd
    return np.array(pd.read_csv(files, usecols=["ARR_DELAY"]))

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

# looping in python
jobs1 = [(input1,
          job_server.submit(kludgy_read_csv_wrapper1,
                            (input1,))) for input1 in yr_by_yr_files]

jobs2 = [(input2,
          job_server.submit(kludgy_read_csv_wrapper2,
                            (input2,))) for input2 in mnth_by_mnth_files]

# wait for all jobs to finish
job_server.wait()
delay = np.array([])
for input, job1 in jobs1:
    delay = np.append(delay, job1())

for input2, job2 in jobs2:
    delay = np.append(delay,job2())

# one can parallelize the following but it's not worth the overhead
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
