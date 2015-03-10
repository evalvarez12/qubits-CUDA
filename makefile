-include ~/makefile

LDLIBS = -litpp
NVCCFLAGS= -arch=sm_13

ifeq ($(LOGNAME),eduardo)
  INCLUDES := -I ../libs/
endif
# }}}


mein :: mein.cpp
	g++ $(INCLUDES) $< -o $@ $(LDLIBS)

abc :: abc.cu 
	nvcc $(INCLUDES) $< -o $@ $(LDLIBS)
	
