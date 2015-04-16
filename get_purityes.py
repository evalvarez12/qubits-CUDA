from pylab import *
import os
import conexiones as conx

#VARIANDO NUMEROS CONEXIONES
#for i in range(1,15) :
  #dat_i=str(i)+".dat"
  #jp=.75*(6./sqrt(double(i)))
  ##jp=0.75
  #comando = "./abc -o purity -q 17 --x 6 --model modelVar" +str(i)+" --Jc 0.01 --Jp "+str(jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > pur_conexiones-max-2-"
  #os.system(comando + dat_i)
  #print i


#VARIANDO LAMBDA PARA CONEXIONES COMPLETAS
#i=1
#for gamma in [0.01,0.005,0.003,0.001] :
  #dat_i=str(i)+".dat"
  #jp=.75*(6./sqrt(double(i)))
  ##jp=0.75
  #comando = "./abc -o purity -q 17 --x 6 --model modelConexComplete --Jc "+str(gamma)+" --Jp "+str(jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > pur_complete_conexiones-"
  #os.system(comando + dat_i)
  #print i
  #i+=1


#VARIANDO TOPOLOGIAS
for i in range(8) :
  conx.set_conexiones(6,6,10)
  dat_i=str(i+1)+".dat"
  comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > maxpur-randconex-6-"
  os.system(comando + dat_i)
  print i