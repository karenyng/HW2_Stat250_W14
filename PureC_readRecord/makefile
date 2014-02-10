#---------------------------------------------
# Karen Yin Yee Ng 
# Makefile for AirDelay multithreaded program
# This makes all of the required objects 
# and also compile an executable called findDelay 
# --------------------------------------------
EXE = findDelay
COMPILER = g++
COMPILER_OPTS = -c -g -O0 -Wall 
LINKER = g++
LINKER_OPTS = -o 

OBJS = readRecords.o threads.o 

all : $(EXE)

$(EXE) : $(OBJS)
	$(LINKER) $(LINKER_OPTS) $(EXE) $(OBJS)

readRecords.o : readRecords.c readRecords.h  
	$(COMPILER) $(COMPILER_OPTS) readRecords.c 

threads.o : threads.c threads.h readRecords.h  
	$(COMPILER) $(COMPILER_OPTS) threads.c

clean:
	rm -f *.o $(EXE)

