Assignment 2
=============

IPython notebook version of Write up available at:
http://nbviewer.ipython.org/github/karenyng/HW2_Stat250_W14/blob/master/writeup/Stat250%20W14%20HW2.ipynb?create=1#

PDF format available at: 
https://github.com/karenyng/HW2_Stat250_W14/blob/master/writeup/Stat250%20W14%20HW2.pdf

Note:
---- 
Current implementation is not the best. 
For Method 2, should divide up the files according to the number of cores
for doing load balancing appropriately before supplying the list of files to 
"getDelayTable_thread". 

Dependencies:
-----------
* put csv files in ${GITHUB directory}/data/
* python pp package 
* python pandas 
* python numpy 
* python 
* R package inside this repository called AirlineDelays

How to use the code 
--------------------
### Method 1 
For running the python code specifying a certain number of cores, at a terminal run:

    $./method1.py $NUMBER_OF_CORES_TO_USE

For running the python code for a range of cores, modify method1_wrapper.py then run:

    $./method1_wrapper.py

### Method 2 
    $Rscript ./method2.py $NUMBER_OF_FILES_TO_USE

Outputs / results for method 1: 
------------------
* pp_{NUMBER_OF_CORES_USED}.txt
* time_cpus.txt  

