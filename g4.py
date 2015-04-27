from pylab import *
import os
import conexiones as conx



#OBTENER DATOS
#for i in range(2,15,2) :
  #conx.set_conexiones(i,6,10)
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp "+str(i)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica4-2-"
  #os.system(comando + dat_i)
  #print i


  
  
  
#HACER grafica3
lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-']
jps=linspace(0,pi/2,75)
nu=r"\nu"

for i in range(2,15,2) :
  a=loadtxt("grafica4-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+nu+"="+str(i)+"$")


xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)

legend(loc='lower center',fontsize=25)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()