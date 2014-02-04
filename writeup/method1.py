#!/usr/bin/env python
import pandas as pd
import numpy as np
import pp

data_path = "../data/"
ncpus = 3

# have the job server use 4 cores without hyperthreading
job_server = pp.Server(ncpus=ncpus)


def kludgy_read_csv_wrapper1(files):
    import pandas as pd
    return pd.read_csv(files, usecols=["ArrDelay"])


def kludgy_read_csv_wrapper2(files):
    import pandas as pd
    return pd.read_csv(files, usecols=["ARR_DELAY"])


yr_by_yr_files = [data_path + str(i) + ".csv" for i in range(1987, 2008)]
month = ["January", "February", "March", "April", "May", "June",
         "July", "August", "September", "October", "November",
         "December"]
mnth_by_mnth_files = \
    [data_path + str(yr) + "_" + mnth +
     ".csv" for yr in range(2008, 2013) for mnth in month]

print "going to read in the following # of files:" + \
    " {0}".format(len(yr_by_yr_files) + len(mnth_by_mnth_files))

# looping in python
jobs1 = [(input1,
          job_server.submit(kludgy_read_csv_wrapper1,
                            (input1,))) for input1 in yr_by_yr_files]

jobs2 = [(input2,
          job_server.submit(kludgy_read_csv_wrapper2,
                            (input2,))) for input2 in mnth_by_mnth_files]

delay1 = pd.DataFrame()
for input, job1 in jobs1:
    #delay1 = delay1.append(job1())
    for i in range(job1().shape[0]):
        a = job1()["ArrDelay"][i]

#delay2 = pd.DataFrame()
for input2, job2 in jobs2:
    for i in range(job2().shape[0]):
        a = job2()["ARR_DELAY"][i]
#    delay2 = delay2.append(job2())

#delay2 = np.array(delay2)
#delay2 = pd.DataFrame(delay2, columns=["ArrDelay"])
#total_delay = delay1.append(delay2)
#
#mean = total_delay.mean()
#sd = total_delay.std()
#median = total_delay.median()
#
#print "mean = {0}".format(mean[0])
#print "sd = {0}".format(sd[0])
#print "median = {0}".format(median[0])
