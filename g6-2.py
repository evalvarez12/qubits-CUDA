from pylab import *
import os
import conexiones as conx
#import nodos as nod



#OBTENER DATOS
#for i in range(1,7) :
  #conx.set_conexiones(4,6,10)
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica6-c4-"
  #os.system(comando + dat_i)
  #print i

#for i in range(1,7) :
  #conx.set_conexiones(8,6,10)
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica6-c8-"
  #os.system(comando + dat_i)
  #print i

#for i in range(1,7) :
  #conx.set_conexiones(12,6,10)
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica6-c12-"
  #os.system(comando + dat_i)
  #print i

#for i in range(1,7) :
  #conx.set_conexiones(16,6,10)
  #dat_i=str(i)+".dat"
  #comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica6-c16-"
  #os.system(comando + dat_i)
  #print i

  
  
  
#HACER grafica6
lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-','D-','v-']
jps=linspace(0,pi/2,76)
nu="\mu"
labels=['A','B','C','D','E','F']

fig=figure()

ylabel("$P$ \n",fontsize=30)
xlabel("\n $\gamma$",fontsize=30)
xticks([])
yticks([])

fig.add_subplot(2,2,1)

for i in range(1,7) :
  a=loadtxt("grafica6-c4-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")



xticks(arange(0,pi/2+.1,pi/4),('','',''),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$ \n $0.9$'),fontsize=25)


text(pi/4-.2,0.6,r'$\nu=4$',fontsize=28)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)

fig.add_subplot(2,2,2)

for i in range(1,7) :
  a=loadtxt("grafica6-c8-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")



xticks(arange(0,pi/2+.1,pi/4),('','',''),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('','','','',''),fontsize=25)


text(pi/4-.2,0.6,r'$\nu=8$',fontsize=28)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


fig.add_subplot(2,2,3)

for i in range(1,7) :
  a=loadtxt("grafica6-c12-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")



xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$ $0$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)


text(pi/4-.2,0.6,r'$\nu=12$',fontsize=28)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


fig.add_subplot(2,2,4)

for i in range(1,7) :
  a=loadtxt("grafica6-c16-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")



xticks(arange(0,pi/2+.1,pi/4),('','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('','','','',''),fontsize=25)


text(pi/4-.2,0.6,r'$\nu=16$',fontsize=28)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)






fig.subplots_adjust(hspace=0,wspace=0)
show()