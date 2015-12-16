from pylab import *
import os



#OBTENER DATOS

#dat_i=".dat"
#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op1 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-1-"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op2 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-2-"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op3 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-3-"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op4 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-4-"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op5 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-5-"
#os.system(comando + dat_i)

#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open_op6 --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-3-6-"
#os.system(comando + dat_i)
  
  
# DATOS
#grafica2-1- para semicadena rara variando conexiones internas
#grafica2-3- como 2-2 pero para 2PI
  
  
#HACER grafica3
import nodos as nod
lines=['bo-','gD-','rp-','cv-','m^-','y>-','H-','d-','x-','s-','+-','D-','v-']
labels=['$\gamma=50\lambda$','$\gamma=100\lambda$','$\gamma=300\lambda$','$\gamma=500\lambda$','$\gamma=800\lambda$','$\gamma=1000\lambda$','$\gamma=1400\lambda$']
jps=linspace(0,pi/2,75)
a=loadtxt("grafica2.dat")
a=a[:-1]
op1=loadtxt("grafica2-op1.dat")
op2=loadtxt("grafica2-op2.dat")

op1=op1[:-1]
op2=op2[:-1]


fig=figure(figsize=(14, 9))

fig.add_subplot(2,1,1)

xticks([])
yticks([])

fig.add_subplot(4,3,1)
nod.nodos1(lines[0])
fig.add_subplot(4,3,2)
nod.nodos2(lines[1])
fig.add_subplot(4,3,3)
nod.nodos3(lines[2])
fig.add_subplot(4,3,4)
nod.nodos4(lines[3])
fig.add_subplot(4,3,5)
nod.nodos5(lines[4])
fig.add_subplot(4,3,6)
nod.nodos6(lines[5])


fig.add_subplot(2,1,2)

jps=linspace(0,2*pi,151)
for i in range(1,7) :
  a=loadtxt("grafica2-3-"+str(i)+"-.dat")
  plot(jps,a,lines[i-1],markevery=1)

  

xlabel("$\gamma$",fontsize=28)

xticks((0,pi/2,pi,(3/2.)*pi,2*pi),('$0$','$\pi/2$','$\pi$','$3/2\pi$','$2\pi$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)

axis([0,2*pi,0.5,.85])
#legend(loc='lower center',fontsize=25)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)

fig.subplots_adjust(hspace=0,wspace=0)
savefig('art-g2-2.png')