-include ~/makefile

LDLIBS = -litpp
NVCCFLAGS= -arch=sm_13
GCCBIND = --compiler-bindir /usr/bin/g++-4.8.4 


ifeq ($(LOGNAME),eduardo)
  INCLUDES := -I ../libs/
endif
# }}}


mein :: mein.cpp
	g++ $(INCLUDES) $< -o $@ $(LDLIBS)

abc :: abc.cu 
	nvcc $(GCCBIND) $(INCLUDES) $< -o $@ $(LDLIBS)
	
