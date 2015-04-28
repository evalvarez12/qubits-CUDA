from pylab import *
import os



#OBTENER DATOS

#dat_i=".dat"
#comando = "./abc -o purity_gamma -q 17 --x 6 --model model3_open --Jc 0.01 --Jp 1. --Js 1. --DJs 0.2 --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > grafica2-4"
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
plot(jps,op1,'k--')
plot(jps,op2,'k--')

for i in [3,6] :
  b=loadtxt("grafica2-"+str(i)+".dat")
  b=b[:-1]
  plot(jps,b,'k--')
  
plot(jps,a,linewidth=2)
xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)


yticks((0.8,0.7,0.6,0.5),('$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=25)
ylabel("$P$",fontsize=28)



tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()