from pylab import *
import os
import conexiones as conx



#OBTENER DATOS
#j=1
#for i in [[6,10],[7,12],[8,14],[10,14]] :
  ##conx.set_conexiones(6,i[0],i[1])
  #dat_i=str(j)+".dat"
  #comando = "./abc -o purity_gamma -q "+str(i[0]+i[1]+1)+" --x "+str(i[0])+" --model model3_open --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica5-2-"
  #os.system(comando + dat_i)
  #j+=1



#j=1
#for i in [[5,11],[4,12],[3,13],[2,14],[1,15]] :
  #os.system("cp conexionesAtoB"+str(j)+".txt  conexiones.txt")
  #dat_i=str(j)+".dat"
  #comando = "./abc -o purity_gamma -q "+str(i[0]+i[1]+1)+" --x "+str(i[0])+" --model modelConexRandABC --Jc 0.01 --Jp 1 --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica5-3-"
  #os.system(comando + dat_i)
  #j+=1

  
  
  
#HACER grafica3
lines=['o-','<-','p-','v-','*-','^-','h-','D-','>-','H-','d-','x-','s-','+-']
jps=linspace(0,pi/2,76)
nu="\mu"
#dims=[[6,10],[7,12],[8,14],[10,14]]
dims=[[5,11],[4,12],[3,13],[2,14],[1,15]]

for i in range(1,5) :
  a=loadtxt("grafica5-2-"+str(i)+".dat")
  plot(jps,a,lines[i-1],label="$N_e="+str(dims[i-1][0])+"$ $N_{e^\prime}="+str(dims[i-1][1])+"$")


xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)

axis([0,pi/2.,0.5,.8])

legend(loc='lower center',fontsize=25)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()