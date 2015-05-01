from pylab import *
import os

#PARAMETROS FIJOS
Js,DJs,Dbs,bx_no,bz=[1.,0.,0.,1.,1.] 


#OBTENER DATOS

#for lamb in log10(logspace(0,0.1,100)) :
  #dat_i=".dat"
  #comando = "./abc -o purity_onet -q 17 --x 6 --model model3_open --Jc "+str(lamb)+" --Jp 0.5 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  >> grafica3-gamma_0.5"
  #os.system(comando + dat_i)
  #print lamb

#for lamb in log10(logspace(0,0.1,100)) :
  #dat_i=".dat"
  #comando = "./abc -o purity_onet -q 17 --x 6 --model model3_open --Jc "+str(lamb)+" --Jp 0.1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  >> grafica3-gamma_0.1"
  #os.system(comando + dat_i)
  #print lamb
  
#for lamb in log10(logspace(0,0.1,100)) :
  #dat_i=".dat"
  #comando = "./abc -o purity_onet -q 17 --x 6 --model model3_open --Jc "+str(lamb)+" --Jp 0.01 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  >> grafica3-gamma_0.01"
  #os.system(comando + dat_i)
  #print lamb
  
 
    
  
#HACER grafica3
a=loadtxt("grafica3-gamma_0.5.dat")
b=loadtxt("grafica3-gamma_0.1.dat")
c=loadtxt("grafica3-gamma_0.01.dat")
lamb=log10(logspace(0,0.1,100))

plot(lamb,log10(1-a),'k-',label='$\gamma=0.5$')
plot(lamb,log10(1-b),'k--',label='$\gamma=0.1$')
plot(lamb,log10(1-c),'k:',label='$\gamma=0.01$')

xlabel("$\lambda$",fontsize=28)
#xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
xscale('log',basex=10)
xticks((.001,0.01,.1),('$10^{-3}$','$10^{-2}$','$10^{-1}$'),fontsize=25)
yticks((0,-1,-2),('$0$','$-1$','$-2$'),fontsize=25)
ylabel("$\log(1-P)$",fontsize=28)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)

axis([.001,.1,-3,0])

legend(loc='lower right',fontsize=25)

show()