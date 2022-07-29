
#------------------------------------------------------------------#
# Makefile for compilation of C/C++ library for python using boost #
#------------------------------------------------------------------#

# OS selection
UNAME_S := $(shell uname -s)
ifeq ($(findstring MINGW64_NT, $(UNAME_S)),MINGW64_NT)
    UNAME_S := mingw64
else ifeq ($(UNAME_S), Linux)
	UNAME_S := linux
else
	$(error OS not Supported)
endif

# Target name
TARGET  	:= main

# Directories
SRCDIR      := ./src
INCDIR      := ./include
BUILDDIR    := ./.build

# Compiler
CC 			:= g++

# Extensions
SRCEXT      := cpp
OBJEXT      := o


# Flags, Libraries and Includes
# edit these for different version of python and/or different path
CFLAGS      := #-fpic #-shared -static
ifeq ($(UNAME_S), linux)
LIB			:= 
INC         := -I$(INCDIR) 
else
LIB			:= -lws2_32 
INC         := -I$(INCDIR)
endif


#---------------------------------------------------------------------------------
#DO NOT EDIT BELOW THIS LINE
#---------------------------------------------------------------------------------

# Find all sources in SRCDIR
SOURCES     := $(shell find $(SRCDIR) -type f -name *.$(SRCEXT)) 

# One object file for each source file in BUILDDIR
OBJECTS     := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.$(SRCEXT)=.$(OBJEXT)))

# Link objects files to executable
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) -o $(TARGET) $^ $(LIB)

# Compile object files
$(BUILDDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INC) -c -o $@ $< $(LIB)

# Clean
clean:
	@$(RM) -rf $(BUILDDIR)
	@$(RM) -rf $(TARGET)

# Remake (clean + make)
remake: clean $(TARGET)

# All (make + test)
all: $(TARGET) test

# Test the library
test:
	./$(TARGET)

.PHONY: $(TARGET) clean remake test all