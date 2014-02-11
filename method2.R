#----------------------------------------------------------------------
# Author: Karen Ng <karenyng@ucdavis.edu> 
# calling functions from AirlineDelay package from R in threaded version
# to compute statistics of large CSV files 
#----------------------------------------------------------------------
library(AirlineDelays)

# this numCore variable should be input from the console instead 
numCores <- 10L 

#Initialize some variables  
filepath <- "./data"
#pattern <- "^([0-9]+).csv$"
pattern <- "^2008([a-zA-Z_]+).csv$"
#pattern <- "^1988.csv$"

FILES <- getListOfFiles(filepath, pattern = pattern)
tt <- getDelayTable_thread(FILES, numThreads = as.integer(numCores))

