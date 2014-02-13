#----------------------------------------------------------------------
# Author: Karen Ng <karenyng@ucdavis.edu> 
# calling functions from AirlineDelay package from R in threaded version
# to compute statistics of large CSV files 
#----------------------------------------------------------------------
require(AirlineDelays)

# this numCore variable should be input from the console instead 
numCore <- as.integer(commandArgs(trailingOnly = T))
print(paste("numCore =", numCore))
if(!(is.integer(numCore) && numCore > 0))
  stop("Wrong numCore commandline argument, not integer!")

# ----Initialize some variables ----- 
filepath <- "/mnt/Winter14Stat250/HW2_Stat250_W14/data"
#filepath <- "/mnt/Winter14Stat250/HW2_Stat250_W14/tests"
#pattern <- "^([0-9]+).csv$"
#pattern <- "^2008([a-zA-Z_]+).csv$"
#pattern <- "^198[7-9].csv$"
pattern <- "^([0-9]+)([a-zA-Z_]+)?.csv$"
#pattern <- "^test1.csv$"
FILES <- getListOfFiles(filepath, pattern = pattern)
print(paste("Setting numThreads = number of files input =",
            length(FILES[c(1:numCore)])))
tt <- getDelayTable_thread(FILES[c(1:numCore)], numThreads = numCore)
ans <- freq_mean(tt)
std <- freq_sd(ans[[2]], tt, ans[[1]])


print(paste("freq = ", ans[[1]]))
print(paste("mean = ", ans[[2]]))
print(paste("median = ", median(freq_median(ans[[1]], tt))))
print(paste("std dev.  = ", std))





