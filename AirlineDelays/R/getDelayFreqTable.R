#----------------------------------------------------------------------
# To run roxygen to generate Rd files for documentation
#----------------------------------------------------------------------

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
  suppressWarnings(fieldNum <- i + length(grep(",", as.character(tmp[1,w]))) - 1L)
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
#' @return a dataframe that contains the combined frequency table 
#' @note
#'   Take the files and field numbers and group them
#'   and then divide them into numThreads groups.
#'   for now, require the caller to give us a list with as many elements as there are
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
  tt = .Call("R_threaded_multiReadDelays", files, as.integer(numThreads), TRUE, 
             as.integer(fieldNum))
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
