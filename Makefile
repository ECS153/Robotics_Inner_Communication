R=ar
AS=as
CC=gcc
CPP=cpp
CXX=g++
LD=ld
STRIP = strip

# change according to your architecture
COMPILER=C:\\ARM\\Keil\\v5\\keiluv5.exe

INC_DIR = ./inc
SRC_DIR = ./src
OBJ_DIR = ./obj
BIN_DIR = ./bin

# DEBUG_MODE = TRUE

ifdef DEBUG_MODE
DEFINES += -DDEBUG
FLAGS += -Wall
FLAGS += -g
else
FLAGS += -O3
endif

INCLUDE += -I $(INC_DIR)
FLAGS += -std=c++11
BIN_NAME = simulator

OBJS = $(OBJ_DIR)/main.o 

# TODO
lib:
	echo "Not implemented yet!"

test: directories $(BIN_DIR)/$(BIN_NAME)

$(BIN_DIR)/$(BIN_NAME): $(OBJS)
	$(CXX) $(OBJS) -o $(BIN_DIR)/$(BIN_NAME) $(FLAGS) $(DEFINES)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp $(INC_DIR)/%.hpp
	$(CXX) $(FLAGS) $(DEFINES) $(INCLUDE) -c $< -o $@

.PHONY: directories
directories:
	mkdir -p $(OBJ_DIR) && mkdir -p $(BIN_DIR)

.PHONY: clean
clean:
	rm -f $(OBJ_DIR)/*.o && rm -f $(BIN_DIR)/*
