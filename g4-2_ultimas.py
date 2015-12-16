#from pylab import *
import os
#import conexiones as conx



for i in range(1,5) :
  os.system("cp ultimas_conex_"+str(i)+".txt conexiones.txt " )
  dat_i=str(i)+".dat"
  comando = "./abc -o purity_gamma -q 17 --x 6 --model modelConexRandABC --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs -2 --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica4-muerte"
  os.system(comando + dat_i)
  print i


  
  
##HACER grafica3
#lines=['s-','<-','p-','v-','D-','H-','D-','h-','>-','H-','d-','x-','s-','+-']

#for i in [4,8,12,14] :
  #a=loadtxt("grafica4-2-pt-"+str(i)+".dat")
  #plot(a,lines[i-1],markevery=60,label=r"$\nu="+str(i)+"$")
  
  
  




#xlabel("$t$",fontsize=28)
##xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
#xticks((500,1000,1500,2000,2500),('$500$','$1000$','$1500$','$2000$','$2500$'),fontsize=25)
#yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
#ylabel("$P$",fontsize=28)

#legend(loc='lower left',fontsize=25)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)



##INSET
#ax = axes([.55, .65, .33, .22])
#jps=linspace(0,pi/2,75)

#for i in [4,8,12,14] :
  #ains=loadtxt("grafica4-"+str(i)+".dat")
  #jps2=jps/sqrt(i)
  #plot(jps2,ains,lines[i-1])
  #xticks((0,pi/16,pi/8),('$0$','$\pi/16$','$\pi/8$'),fontsize=25)
  #yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
  #setp(ax, xlim=(0,pi/8))
  

#xlabel("$\gamma^{\prime}$",fontsize=28)
#ylabel("$P$",fontsize=28)
#show()