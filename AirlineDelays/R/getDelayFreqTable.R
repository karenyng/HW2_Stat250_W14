#----------------------------------------------------------------------
# To run roxygen2 to generate Rd files for proper documentation
#----------------------------------------------------------------------
#' @useDynLib AirlineDelays
#' @name getDelayTable
#' @title single threaded version for gettign a freq table from csv file 
#' @param filename the name of local csv file 
#' @param fieldNum an integer denoting the number of the field to get 
#' @return a numeric vector denoting the table 
#' @seealso \code{\link[base]{read.csv}}
#'   \code{\link[base]{file}}
#' @examples getDelayTable("~/Data/Airline/Airlines/1987.csv", 15L)
#' @keywords IO
#' @export
getDelayTable =
function(filename, fieldNum = getFieldNum(filename))
{
  tt = .Call("R_getFileDelayTable", path.expand(filename), TRUE, 
             as.integer(fieldNum))
  tt[tt > 0]
}


#' @name getFieldNum
#' @title read csv header to get appropriate column number  
#' @note not sure that it finds the number correctly due to possible "," 
#'   inside the fields 
#' @param filename the name of local csv file 
#' @param fieldNum an integer denoting the number of the field to get 
#' @return an integer denoting the column number  
#' @examples getFieldNum("~/Data/Airline/Airlines/1987.csv")
#' @keywords IO
getFieldNum =
function(filename)
{
  d = read.csv(filename, nrows = 1, stringsAsFactors = FALSE)
  i = which(names(d) == "ARR_DELAY" | names(d) == "ArrDelay")

  tmp = d[1, 1:(i-1)]

  w = sapply(tmp, is.character)
  # I believe the following line attempt to correct for the comma in a field
  # the check should be done across all the field - i 'm not sure 
  # if this is done quite correctly?...
  suppressWarnings(fieldNum <- 
                        i + length(grep(",", as.character(tmp[1,w]))) - 1L)
  #print(paste("getFieldNum returns", fieldNum))
  fieldNum
}


#' @name getDelayTable_thread
#' @title returns a freq table of delay times 
#' @param files 
#'   R list that contains path to files - has to be a list, c() does not
#'   work 
#' @param fieldNum 
#'   R integer that denotes the fieldNum 
#' @param numThreads 
#'   R integer that denotes the num of threads to be used 
#' @return a vector that contains the combined frequency table 
#' @note
#'   Take the files and field numbers and group them
#'   and then divide them into numThreads groups.
#'   for now, require the caller to give us a list with as many elements as
#'   there are
#'   threads and each element is a character vector of the file names to
#'   process in that thread.
#'   right now the function will give error since files is a list of
#'   filenames but perhaps not the entire file path is specified correctly  
#' @export
getDelayTable_thread =
function(files, fieldNum = sapply(files, getFieldNum), numThreads = 4L)
{
  numThreads <- checkInputsForErrors(files, numThreads)
#  fnames = split(files, fieldNum)
  tt = .Call("R_threaded_multiReadDelays", files, 
             as.integer(numThreads), TRUE, as.integer(fieldNum))
  tt[tt > 0]
}



#' @name getListOfFiles
#' @title return a list of filenames 
#' @param filepath 
#'   string that contains the path to the directory containing the files 
#' @param  pattern 
#'   string that denotes the regular expression for matching file names 
#' @param full.names 
#' @return FILES 
#'   R list of filenames 
#' @seealso \code{\link[base]{list.files}}
#' @export
getListOfFiles = 
function(filepath, pattern = NULL, full.names = TRUE)
{  
  # list all the files in the relevant diretory
  files = list.files(filepath, pattern = pattern, full.names = TRUE)
  if(length(files) == 0)
  {
    stop(paste("Failed to read in files at", filepath))
  }
   
  # function that Duncan wrote only likes lists 
  # so have to rearrange the file paths as lists 
  FILES <- list()
  for(i in 1:length(files))
  {
    FILES <- append(FILES, list(files[i])) 
  }
  FILES
}


#' @name checkInputsForErrors 
#' @title check for input errors 
#' @param FILES 
#'   R list of files 
#' @param numCores  
#'  an integer that denotes the number of cores to be used  
#' @note this suppresses a possible memory error 
#' @return numCores 
#'  an integer that denotes numCore that will not cause memory error
#' @export
checkInputsForErrors =
function(FILES, numCores)
{
 if(length(FILES) < as.integer(numCores)){
   print("Number of files supplied < number of threads!!")
   print("setting numCores = number of files")
   numCores <- length(FILES)
 }
 numCores
}


#' @name freq_mean
#' @title compute mean from frequency table
#' @param tt 
#'   vector with count as field value, column name as delay
#' @param w.total
#'   integer denoting total frequency count 
#' @return list of 
#'   total freq. count, mean 
#' @export
freq_mean = 
function(tt)
{
  print(tt)
  df <- as.data.frame(tt)
  # store them as double to avoid numerical instabilities
  delay <- sapply(rownames(df), as.double)  
  w.total <- sum(df[,c('tt')]) 
  # would there be overflow? or underflow for the following line?
  t.mean <- sum(df[,c('tt')] * ( delay / w.total), na.rm = TRUE)

  c(w.total, t.mean)
}


#' @name freq_median
#' @title compute median from frequency table
#' @param w.total
#'   integer denoting total frequency count 
#' @param tt 
#'   vector with count as field value, column name as delay
#' @return median 
#'   double
#' @export
freq_median = 
function(w.total, tt)
{
  i <- 1
  df <- as.data.frame(tt)
  delay <- sapply(rownames(df), as.double)  
  Sum <- df[['tt']][i]

  medianFreqCount <- floor(w.total / 2) 
  ## sorry don't know better than to write a loop...
  while(Sum < medianFreqCount) { 
    i <- i + 1 
    # this vectorized operation 
    Sum <- sum(df[['tt']][1:i], na.rm = TRUE)
    # is faster than 
    ## if ( !is.na(DF[['freq']][i]) ) {
    ##   Sum <- Sum + DF[['freq']][i] 
    ## }
  }

  ## check for corner case:  
  ## or else there the median will may be off  
  print("compute_stat.R: computing standard dev.")
  if( Sum == medianFreqCount &&  w.total %% 2 == 0){
    # print("going through special case")
    t.median <- (delay[i] + delay[i+1])/2   
  }else{
    t.median <- delay[i]
  }
}

#' @name sd
#' @title compute sd from frequency table
#' @param t.mean
#'   double denoting the mean
#' @param w.total
#'   integer denoting total frequency count 
#' @param tt 
#'   vector with count as field value, column name as delay
#' @return median 
#'   double
#' @export
sd = 
function(t.mean, tt, w.total)
{
  df <- as.data.frame(tt)
  delay <- sapply(rownames(df), as.double)  
  std.dev <- sqrt(sum(df[,c('tt')] * (delay - t.mean) ^ 2 / (w.total-1))) 
}
