from pylab import *
import os



#OBTENER DATOS

#dat_i=".dat"
#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open --Jc 0.01  --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica2"
#os.system(comando + dat_i)


  
  
  
#HACER grafica3
#lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']
#labels=['$\gamma=50\lambda$','$\gamma=100\lambda$','$\gamma=300\lambda$','$\gamma=500\lambda$','$\gamma=800\lambda$','$\gamma=1000\lambda$','$\gamma=1400\lambda$']
jps=linspace(0,pi/2,75)
a=loadtxt("grafica2.dat")
plot(jps,a,'k')


xlabel("$\gamma$",fontsize=22)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=15)


yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=15)
ylabel("$P$",fontsize=22)



tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()