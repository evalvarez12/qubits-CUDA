from pylab import *
import os



#OBTENER DATOS

#GAMAS BUENAS=[0.05,0.1,0.3,0.5,0.8,1.,1.4]
i=1
os.system("cp conexiones_int3.txt conexiones.txt " )
for gamma in [0.05,0.1,0.3,0.5,0.8,1.,1.4] :
  dat_i=str(i)+".dat"
  comando = "./abc -o purity -q 17 --x 6 --model modelConexRandABC --Jc 0.01 --Jp "+str(gamma)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs -2 --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica1-12-"
  os.system(comando + dat_i)
  print i
  i+=1
  
  
i=1
os.system("cp conexiones_int5.txt conexiones.txt " )
for gamma in [0.05,0.1,0.3,0.5,0.8,1.,1.4] :
  dat_i=str(i)+".dat"
  comando = "./abc -o purity -q 17 --x 6 --model modelConexRandABC --Jc 0.01 --Jp "+str(gamma)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs -2 --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica1-13-"
  os.system(comando + dat_i)
  print i
  i+=1  
  
#grafica1-3- para conexionesABC7  
#grafica1-4- para conexionesABC-2-6  
#grafica1-5- para conexionesABC-2-4 
#grafica1-6- para conexionesABC7 con campo perpendicular
#grafica1-7- para conexionesABC7 con campo paralelo
#grafica1-8- para conexionesABC-2-6 con campo perpendicular
#grafica1-9- para conexionesABC-2-6 con campo paralelo
#grafica1-10- para conexiones_int3 con campo perpendicular
#grafica1-11- para conexiones_int5 con campo perpendicular


  
  
##HACER grafica
#import nodos as nod
#conx=loadtxt("conexionesABC7.txt")
#conx=conx[1:]
#lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']
#labels=['$\gamma=5\lambda$','$\gamma=10\lambda$','$\gamma=30\lambda$','$\gamma=50\lambda$','$\gamma=80\lambda$','$\gamma=100\lambda$','$\gamma=140\lambda$']
#for i in range(1,7) :
  #a=loadtxt("grafica1-6-"+str(i)+".dat")
  #plot(a,lines[i],markevery=60,label=labels[i-1])


#xlabel("$t$",fontsize=28)
##xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
#xticks((500,1000,1500,2000,2500),('$500$','$1000$','$1500$','$2000$','$2500$'),fontsize=25)
#yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
#ylabel("$P$",fontsize=28)
#text(2000,0.7,'$b \perp J$',fontsize=28)

#legend(loc='lower left',fontsize=25)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)

##INSET
##ax = axes([.55, .65, .33, .22])
#ax = axes([.55, .1, .33, .22])
#nod.nodosABC(conx,'-')

#show()