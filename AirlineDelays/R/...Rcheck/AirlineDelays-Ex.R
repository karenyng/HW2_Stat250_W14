pkgname <- "AirlineDelays"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('AirlineDelays')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
cleanEx()
nameEx("getDelayTable")
### * getDelayTable

flush(stderr()); flush(stdout())

### Name: getDelayTable
### Title: single threaded version for getting a freq table from csv file
### Aliases: getDelayTable
### Keywords: IO

### ** Examples

a1 = getDelayTable("~/Data/Airline/Airlines/1987.csv", 15L)



### * <FOOTER>
###
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
