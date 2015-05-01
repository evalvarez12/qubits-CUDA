from pylab import *
import os
import conexiones as conx
import nodos as nod



#OBTENER DATOS
#for i in range(1,7) :
  #conx.set_conexiones(6,6,10)
  #os.system("cp conexiones.txt conexiones"+str(i)+".txt")
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica6-"
  #os.system(comando + dat_i)
  #print i


  
  
  
#HACER grafica6
lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-','D-','v-']
jps=linspace(0,pi/2,76)
nu="\mu"
labels=['A','B','C','D','E','F']

fig=figure()

fig.add_subplot(2,1,1)

xticks([])
yticks([])

for i in range(1,7) :
  conx=loadtxt("conexiones"+str(i)+".txt")
  conx=conx[1:]
  fig.add_subplot(4,3,i)
  nod.nodos(conx,lines[i-1])
  


fig.add_subplot(2,1,2)

for i in range(1,7) :
  a=loadtxt("grafica6-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")


xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)

#legend(loc='upper left',fontsize=25)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)

fig.subplots_adjust(hspace=0,wspace=0)
show()