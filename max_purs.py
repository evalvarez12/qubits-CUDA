from pylab import *
import os


#veces=5
jps=linspace(0,pi/2,150)
for i in range(1,15) :
  for Jp in jps :
    dat_i=str(i)+".dat"
    comando="./abc -o purity_onet -q 17 --x 6 --model modelVar" +str(i)+" --Jc 0.01 --Jp "+str(Jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  >> maxpur-"
    os.system(comando + dat_i)
  print i
        
