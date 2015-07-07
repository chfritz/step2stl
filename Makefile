UNAME := $(shell uname -a)
OCEINCLUDE := $(shell if test -d /usr/local/include/oce; then echo "/usr/local/include/oce"; else echo ""; fi)

OCCLIBS=-lTKBRep -lTKG2d -lTKG3d -lTKGeomBase \
-lTKMath -lTKMesh -lTKSTEP -lTKSTEP209 \
-lTKSTEPAttr -lTKSTEPBase -lTKSTL -lTKXSBase -lTKernel \

ifeq "$(OCEINCLUDE)" ""

#CXX=gcc-4.4
CXXFLAGS += -I/usr/include/opencascade
LDFLAGS += -L/usr/lib/opencas -L/usr/lib ${OCCLIBS}

else

CXXFLAGS += -I/usr/local/include/oce
LDFLAGS += -L/usr/local/lib ${OCCLIBS}

endif

# Required to compile on gentoo systems.

ifeq (gentoo,$(findstring gentoo,$(UNAME)))
CXXFLAGS = -I/usr/lib64/opencascade-6.5/ros/lin/inc
LDFLAGS = -L/usr/lib64/opencascade-6.5/ros/lin/lib64 ${OCCLIBS} -lGL
endif

# note that in ubuntu oneiric you will want to use gcc-4.4, since the
# opencascade libraries don't seem wotk work with 4.6 (because they
# were probably compiled with 4.4). on ifab.parc.com i just made 4.4
# the default.

ifeq (Ubuntu,$(findstring Ubuntu,$(UNAME)))
#UBUNTUDISTRO := $(shell lsb_release -c)
#ifeq (oneiric,$(findstring oneiric,$(UBUNTUDISTRO)))
CXX=gcc-4.4
#endif
endif

#---------------------------------------------------------------------
#targets
#---------------------------------------------------------------------

ifeq "$(MAKECMDGOALS)" ""
 CXXFLAGS += -ggdb3
endif
ifeq "$(MAKECMDGOALS)" "profile"
 CXXFLAGS += -pg -ggdb3
 LDFLAGS += -pg
endif

# Determine where we should output the object files.
OUTDIR = debug
ifeq "$(MAKECMDGOALS)" "debug"
 OUTDIR = debug	
 CXXFLAGS += -ggdb3
endif
ifeq "$(MAKECMDGOALS)" "release"
 OUTDIR = release
 CXXFLAGS += -O3
endif
ifeq "$(MAKECMDGOALS)" "profile"
 OUTDIR = profile
endif

# Add .d to Make's recognized suffixes.
SUFFIXES += .d

# We don't need to clean up when we're making these targets
NODEPS:=clean

#Find all the C++ files in the src/ directory
#SOURCES:=$(shell find * -name '*.cpp' | sort)
SOURCES:=$(shell ls *.cpp | sort)
OBJS:=$(patsubst %.cpp,%.o,$(SOURCES))

#These are the dependency files, which make will clean up after it creates them
DEPFILES:=$(patsubst %.cpp,%.d,$(SOURCES))

#Don't create dependencies when we're cleaning, for instance
ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
    -include $(DEPFILES)
endif

EXE = step2stl


ifeq (Darwin,$(findstring Darwin,$(UNAME)))
	SHARED=-dynamiclib -flat_namespace
	SHAREDLIB=step2stl.so.dylib
else
	SHARED=-fPIC -shared
	SHAREDLIB=step2stl.so
endif



all:	$(EXE)

lib:
	c++ -I/usr/local/include/oce -O3 -L/usr/local/lib -lTKBRep -lTKG2d -lTKG3d -lTKGeomBase -lTKMath -lTKMesh -lTKSTEP -lTKSTEP209 -lTKSTEPAttr -lTKSTEPBase -lTKSTL -lTKXSBase -lTKernel -o $(SHAREDLIB) $(SHARED) lib.cpp
	ffi-generate -f lib.hpp -l $(SHAREDLIB) | sed "s/exports.\([^\.]*\)\.[^ ]*/exports.\1/" > node-ffi.js

debug:	$(EXE)

release:$(EXE)

profile:$(EXE)

$(EXE): $(OBJS)
	$(CXX) $(LDFLAGS) -o $@ $(OBJS)

#This is the rule for creating the dependency files
deps/%.d: %.cpp
	$(CXX) $(CXXFLAGS) -MM -MT '$(patsubst src/%,obj/%,$(patsubst %.cpp,%.o,$<))' $< > $@

#This rule does the compilation
obj/%.o: %.cpp %.d %.h
	@$(MKDIR) $(dir $@)
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# make clean && svn update
clean:
	bash -c 'rm -f *.o $(OBJS) $(EXE)'


