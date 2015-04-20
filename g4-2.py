from pylab import *
import os
import conexiones as conx



#OBTENER DATOS
#for i in range(1,15) :
  #dat_i=str(i)+".dat"
  #jp=.75*(1./sqrt(double(i)))
  #conx.set_conexiones(i,6,10)
  #comando = "./abc -o purity -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp "+str(jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica4-2-pt-"
  #os.system(comando + dat_i)
  #print i

  
  
  
#HACER grafica3
lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-']


for i in range(1,15) :
  a=loadtxt("grafica4-2-pt-"+str(i)+".dat")
  plot(a,'k'+lines[i-1],markevery=60,label="$\mu="+str(i)+"$")


xlabel("$t$",fontsize=22)
#xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
xticks((500,1000,1500,2000,2500),('$500$','$1000$','$1500$','$2000$','$2500$'),fontsize=15)
yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=15)
ylabel("$P$",fontsize=22)

legend(loc='lower left')

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()