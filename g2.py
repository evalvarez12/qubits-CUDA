from pylab import *
import os
import nodos as nod


#OBTENER DATOS

#dat_i=".dat"
#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open --Jc 0.01 --Jp 1. --Js 1. --DJs 0.2 --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open --Jc 0.01 --Jp 1. --Js 1. --DJs 0.2 --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-5"
#os.system(comando + dat_i)


#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open --Jc 0.01 --Jp 1. --Js 1. --DJs 0.2 --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-6"
#os.system(comando + dat_i)  
  
  
#HACER grafica3
lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']
labels=['$\gamma=50\lambda$','$\gamma=100\lambda$','$\gamma=300\lambda$','$\gamma=500\lambda$','$\gamma=800\lambda$','$\gamma=1000\lambda$','$\gamma=1400\lambda$']
jps=linspace(0,pi/2,75)
a=loadtxt("grafica2.dat")
a=a[:-1]
op1=loadtxt("grafica2-op1.dat")
op2=loadtxt("grafica2-op2.dat")

op1=op1[:-1]
op2=op2[:-1]


fig=figure()

fig.add_subplot(2,1,1)

xticks([])
yticks([])

fig.add_subplot(2,3,1)
nod.nodos1('o')
fig.add_subplot(2,3,2)
nod.nodos2('v')
fig.add_subplot(2,3,3)
nod.nodos3('D')


fig.add_subplot(2,1,2)

plot(jps,a,'o-',label='$A$')
plot(jps,op1,'v-',label='$B$')
plot(jps,op2,'D-',label='$C$')

  

xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)

#legend(loc='lower center',fontsize=25)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)

fig.subplots_adjust(hspace=0,wspace=0)
show()