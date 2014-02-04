#----------------------------------------------------------------------
# Author: Karen Ng <karenyng@ucdavis.edu>
# Helper functions for computing mean, median and std dev. of
# a bunch of large csv files
# this is supposed to be a prototype for a later C / C++ version of
# the same code
#----------------------------------------------------------------------


def kludgy_read_csv_wrapper1(files):
    import pandas as pd
    return pd.read_csv(files, usecols=["ArrDelay"])


def kludgy_read_csv_wrapper2(files):
    import pandas as pd
    return pd.read_csv(files, usecols=["ARR_DELAY"])
