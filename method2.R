#----------------------------------------------------------------------
# Author: Karen Ng <karenyng@ucdavis.edu> 
# calling functions from AirlineDelay package from R in threaded version
# to compute statistics of large CSV files 
#----------------------------------------------------------------------
require(AirlineDelays)

# this numCore variable should be input from the console instead 
numCores <- 1L 

#Initialize some variables  
#filepath <- "/mnt/Winter14Stat250/HW2_Stat250_W14/data"
filepath <- "/mnt/Winter14Stat250/HW2_Stat250_W14/tests"
#pattern <- "^([0-9]+).csv$"
#pattern <- "^2008([a-zA-Z_]+).csv$"
#pattern <- "^1987.csv$"
pattern <- "^test.csv$"

FILES <- getListOfFiles(filepath, pattern = pattern)
tt <- getDelayTable_thread(FILES, numThreads = as.integer(numCores))
print(freq_mean(tt))






