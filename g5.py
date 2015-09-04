
import os
#import conexiones as conx



#OBTENER DATOS
#j=1
#for i in [[6,10],[7,12],[8,14],[10,14]] :
  ##conx.set_conexiones(6,i[0],i[1])
  #dat_i=str(j)+".dat"
  #comando = "./abc -o purity_gamma -q "+str(i[0]+i[1]+1)+" --x "+str(i[0])+" --model model3_open --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica5-2-"
  #os.system(comando + dat_i)
  #j+=1



j=1
#os.system("cp conexionesABC7.txt  conexiones.txt")
for i in [[6,10],[8,12],[10,14]] :
  dat_i=str(j)+".dat"
  comando = "./abc -o purity_gamma -q "+str(i[0]+i[1]+1)+" --x "+str(i[0])+" --model modelVar14 --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica5-6-"
  os.system(comando + dat_i)
  j+=1


#grafica5-2 :  [[6,10],[7,12],[8,14],[10,14]]
#grafica5-3 :  [[5,11],[4,12],[3,13],[2,14],[1,15]]
#grafica5-4 :  [[6,10],[6,12],[6,15]]
#grafica5-5 :  [[6,10],[8,10],[10,10]]
#grafica5-6 : arreglando el [[6,10],[8,12],[10,14]]
  
##HACER grafica3
#from pylab import *
#lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-']
#jps=linspace(0,pi/2,76)
#nu="\mu"



#fig=figure()

#ylabel("$P$ \n",fontsize=30)
#xlabel("\n $\gamma$",fontsize=30)
#xticks([])
#yticks([])

#fig.add_subplot(2,1,1)

#xticks([])
#yticks([])

#fig.add_subplot(2,2,1)


#dims=[[6,10],[6,12],[6,15]]
#for i in range(1,4) :
  #a=loadtxt("grafica5-4-"+str(i)+".dat")
  #plot(jps,a,lines[i-1],label="$N_{e^\prime}="+str(dims[i-1][1])+"$")



#xticks(arange(0,pi/2+.1,pi/4),('','',''),fontsize=25)


#yticks((0.9,0.8,0.7,0.6,0.52),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)


#axis([0,pi/2,.5,.9])

#text(pi/4,0.65,'$N_e=6$',fontsize=28)

#legend(loc='lower center',fontsize=25)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)

#fig.add_subplot(2,2,2)

#dims=[[6,10],[8,10],[10,10]]
#for i in range(1,4) :
  #a=loadtxt("grafica5-5-"+str(i)+".dat")
  #plot(jps,a,lines[i-1],label="$N_e="+str(dims[i-1][0])+"$")



#xticks(arange(0,pi/2+.1,pi/4),('','',''),fontsize=25)


#yticks((0.9,0.8,0.7,0.6,0.5),('','','','',''),fontsize=25)


#axis([0,pi/2,.5,.9])

#legend(loc='lower center',fontsize=25)

#text(pi/4,0.65,"$N_e^{\prime}=10$",fontsize=28)
#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)

#fig.add_subplot(2,1,2)


#dims=[[6,10],[7,12],[8,14],[10,14]]
#for i in range(2,5) :
  #a=loadtxt("grafica5-2-"+str(i)+".dat")
  #plot(jps,a,lines[i-1],label="$N_e="+str(dims[i-1][0])+"$ $N_{e^\prime}="+str(dims[i-1][1])+"$")



#xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


#yticks((0.78,0.7,0.6,0.5),('$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)


#axis([0,pi/2,.5,.8])

#legend(loc='lower center',fontsize=25)

#tick_params(axis='both',          # changes apply to the x-axis
    #which='both',      # both major and minor ticks are affected
    #bottom='on',      # ticks along the bottom edge are off
    #top='on',         # ticks along the top edge are off
    #labelbottom='on',
    #length=10)

#fig.subplots_adjust(hspace=0,wspace=0)
#show()