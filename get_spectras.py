from pylab import *
import os

#PARAMETROS FIJOS
Jc,Js,DJs,Dbs,bx_no,bz=[0,0.8,0.1,0.,0.8,0.8] 


i=0
for bz in linspace(0.,1.,100) :
  dat_i="spectra_dos_symr1_"+str(i)+".dat"
  comando = "./abc -o get_spectra -q 10 --model chain_open --Jc 0 --Js 1. --DJs 0 --Dbs 0 --bz " + str(bz) + " --bx 1.4 --PARAMseed 23343 --Eseed 4456 --Cseed 9834 --symR 1 > spectra/"
  os.system(comando + dat_i)
  
  dat_i="spectra_dos_symr2_"+str(i)+".dat"
  comando = "./abc -o get_spectra -q 10 --model chain_open --Jc 0 --Js 1. --DJs 0 --Dbs 0 --bz " + str(bz) + " --bx 1.4 --PARAMseed 23343 --Eseed 4456 --Cseed 9834 --symR -1 > spectra/"
  os.system(comando + dat_i)
  
  i+=1



#i=0
#for bz in linspace(0,1.0,100) :
  #dat_i="spectra_dos_"+str(i)+".dat"
  #comando = "./abc -o get_spectra -q 10 --model chain --Jc 0 --Js 1. --DJs 0.1 --Dbs 0 --bz " + str(bz) + " --bx 1.4 --PARAMseed 23343 --Eseed 4456 --Cseed 9834 > spectra/"
  #os.system(comando + dat_i)
  #i+=1
  
  
  
