from pylab import *
import os

#PARAMETROS FIJOS
Js,DJs,Dbs,bx_no,bz=[1.,0.,0.,1.,1.] 


#OBTENER DATOS
for lamb in linspace(0,0.1,100) :
  dat_i=".dat"
  comando = "./abc -o purity_onet -q 17 --x 6 --model modelVar8 --Jc "+str(lamb)+" --Jp 0.1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  >> grafica3-2-gamma_0.01"
  os.system(comando + dat_i)
  print lamb
  
  
  
##HACER grafica3
#a=loadtxt("grafica3-gamma_0.01.dat")
#lamb=linspace(0,0.1,100)

#plot(log(lamb),log(1-a),'k')

#xlabel("$ln(\lambda)$",fontsize=22)
##xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
#xticks((log(.001),log(0.01),log(.1)),('$ln(0.001)$','$ln(0.01)$','$ln(0.1)$'),fontsize=15)
#yticks((0,-2,-4,-6),('$0$','$-2$','$-4$','$-6$'),fontsize=15)
#ylabel("$ln(1-P)$",fontsize=22)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)


#show()