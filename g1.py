from pylab import *
import os



#OBTENER DATOS
#i=1
#for gamma in [0.05,0.1,0.3,0.5,0.8,1.,1.4] :
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity -q 17 --x 6 --model model3_open --Jc 0.001 --Jp "+str(gamma)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica1-2-"
  #os.system(comando + dat_i)
  #print i
  #i+=1
  
  
  
#HACER grafica3
lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']
labels=['$\gamma=50\lambda$','$\gamma=100\lambda$','$\gamma=300\lambda$','$\gamma=500\lambda$','$\gamma=800\lambda$','$\gamma=1000\lambda$','$\gamma=1400\lambda$']
for i in range(1,8) :
  a=loadtxt("grafica1-2-"+str(i)+".dat")
  plot(a,'k'+lines[i],markevery=60,label=labels[i-1])


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