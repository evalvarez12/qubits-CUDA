from pylab import *
import os

for i in range(1,15) :
  dat_i=str(i)+".dat"
  jp=.75*(6./sqrt(double(i)))
  #jp=0.75
  comando = "./abc -o purity -q 17 --x 6 --model modelVar" +str(i)+" --Jc 0.01 --Jp "+str(jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > pur_conexiones-max-2-"
  os.system(comando + dat_i)
  print i
