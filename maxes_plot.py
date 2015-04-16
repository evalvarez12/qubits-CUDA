from pylab import *

lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']




jps=linspace(0,pi/2,150)

l=0
g=0
lambds=[0.01,0.005,0.003,0.001]
for i in range(4)  :
  a=loadtxt("maxpur-completeconex-"+str(i+1)+".dat")
  plot(jps,a,lines[l],markevery=2,label="$\lambda="+str(lambds[i])+"$")
  g+=1
  l+=1
  
  

#a=loadtxt("maxpur-11.dat")
#plot(jps,a,'d-',markevery=2,label="$COMPLETE$")

#text(1.1,0.7,'$Conexiones=6$ $\lambda=0.01$',fontsize=18)
#axis([0,pi/2,.48,1.05])
legend(loc='upper left')
xlabel("$\gamma$",fontsize=22)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=15)
ylabel("$P$",fontsize=22)

tick_params(axis='x',          # changes apply to the x-axis
    which='minor',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()