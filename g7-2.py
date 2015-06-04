from pylab import *
import os
import conexiones as conx




#PYTHON COLOR CYCLE
# b g r c p y

#OBTENER DATOS
for i in range(1,7) :
  os.system("cp conexiones_int"+str(i)+".txt conexiones.txt " )
  dat_i=str(i)+".dat"
  comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRandABC --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs -2 --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica7-4-"
  os.system(comando + dat_i)
  print i


  
  
#grafica7-4- campo perpendicular para diferentes topos, conexiones_int
  
  
###HACER grafica6
#import nodos as nod
#lines=['bo-','gD-','rp-','cv-','m^-','y>-','H-','d-','x-','s-','+-','D-','v-']
#jps=linspace(0,pi/2,76)
#nu="\mu"
#labels=['A','B','C','D','E','F']

#fig=figure()

#fig.add_subplot(2,1,1)

#xticks([])
#yticks([])



#conexionesB=[[[16,0],[2,10]],[[16,1],[2,10]],[[16,3],[2,10]],[[16,4],[2,10]],[[16,5],[2,10]],[[16,2],[2,10]]]

#for i in range(1,7) :
  #conx=loadtxt("conexiones_int"+str(i)+".txt")
  #conx=conx[1:]
  #fig.add_subplot(4,3,i)
  #nod.nodosABC(conx,lines[i-1])
  


#fig.add_subplot(2,1,2)

#for i in range(1,7) :
  #a=loadtxt("grafica7-4-"+str(i)+".dat")
  #plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")
  
##i=5
##a=loadtxt("grafica7-4-"+str(i)+".dat")
##plot(jps,a,lines[i-1],label="$"+labels[i-1]+"$")
  


#xlabel("$\gamma$",fontsize=28)
#xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


#yticks((0.8,0.7,0.6,0.5),('$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
#ylabel("$P$",fontsize=28)

##axis([0,pi/2,0.5,.8])

##legend(loc='upper left',fontsize=25)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)

#fig.subplots_adjust(hspace=0,wspace=0)
#show()