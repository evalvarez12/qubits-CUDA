from pylab import *
import os
import conexiones as conx



#OBTENER DATOS
#for i in range(1,15) :
  #dat_i=str(i)+".dat"
  #jp=.75*(1./sqrt(double(i)))
  #conx.set_conexiones(i,6,10)
  #comando = "./abc -o purity -q 17 --x 6 --model modelConexRand --Jc 0.01 --Jp "+str(jp)+" --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 2500 --Cseed -1 --Eseed 3462 --PARAMseed 9678  > grafica4-2-pt-"
  #os.system(comando + dat_i)
  #print i

  
  
  
#HACER grafica3
fig=figure(figsize=(9, 6)) # in inches!

lines=['bs-','g<-','rp-','cv-','mD-','yH-','D-','h-','>-','H-','d-','x-','s-','+-']

cont = 0
for i in [4,8,12,14] :
  a=loadtxt("grafica4-2-pt-"+str(i)+".dat")
  plot(a,lines[cont],markevery=60,label=r"$\nu="+str(i)+"$",markersize=10)
  cont += 1
  
  
  




xlabel("$t$",fontsize=17)
#xticks(log(arange(0.000001,.1+.001,.05)),('$0$','$0.05$','$0.1$'),fontsize=15)
xticks((500,1000,1500,2000,2500),('$500$','$1000$','$1500$','$2000$','$2500$'),fontsize=17)
yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=17)
ylabel("$P$",fontsize=28)

legend(loc='lower left',fontsize=17)

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)



#INSET
ax = axes([.55, .65, .33, .22])
jps=linspace(0,pi/2,75)
cont = 0
for i in [4,8,12,14] :
  ains=loadtxt("grafica4-"+str(i)+".dat")
  jps2=jps/sqrt(i)
  plot(jps2,ains,lines[cont],markersize=10)
  xticks((0,pi/16,pi/8),('$0$','$\pi/16$','$\pi/8$'),fontsize=17)
  yticks((0.9,0.8,0.7,0.6,0.5),('$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=17)
  setp(ax, xlim=(0,pi/8))
  cont += 1
  

xlabel("$\gamma^{\prime}$",fontsize=17)
ylabel("$P$",fontsize=17)
savefig('art-g4-4.png')