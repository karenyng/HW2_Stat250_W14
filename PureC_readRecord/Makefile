#---------------------------------------------
# Karen Yin Yee Ng 
# Makefile for AirDelay multithreaded program
# This makes all of the required objects 
# and also compile a main() program 
# for calling the scripts 
# --------------------------------------------

COMPILER = g++
COMPILER_OPTS = -c -g -O0 -Wall 
LINKER = g++
LINKER_OPTS = -o $(NAME_OF_EXECUTABLE_FILE)

OBJS = readrecord.o threads.o  

$(NAME_OF_EXECUTABLE_FILE) : $(OBJS)
	$(LINKER) $(LINKER_OPTS) $(OBJS)

########################################
#linking
all : $(TEST_IMAGE) $(TEST_SCENE)

$(TEST_IMAGE) : $(TEST_IMAGE_OBJS)
	$(LINKER) $(LINKER_OPTS) $(TEST_IMAGE) $(TEST_IMAGE_OBJS)

$(TEST_SCENE) : $(TEST_SCENE_OBJS)
	$(LINKER) $(LINKER_OPTS) $(TEST_SCENE) $(TEST_SCENE_OBJS)

########################################
#compilation

clean:
	rm -f *.o $(TEST_IMAGE) $(TEST_SCENE)

