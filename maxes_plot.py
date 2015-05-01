from pylab import *

lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']




jps=linspace(0,pi/2,150)

l=0
g=0
lambds=[0.01,0.005,0.003,0.001]
for i in range(4)  :
  a=loadtxt("maxpur-completeconex-"+str(i+1)+".dat")
  plot(jps,1-a,lines[l],markevery=2,label="$\lambda="+str(lambds[i])+"$")
  g+=1
  l+=1
  
  

#a=loadtxt("maxpur-11.dat")
#plot(jps,a,'d-',markevery=2,label="$COMPLETE$")

#text(1.1,0.7,'$Conexiones=6$ $\lambda=0.01$',fontsize=18)
#axis([0,pi/2,.48,1.05])
legend(loc='upper center',fontsize=25)
xlabel("$\gamma$",fontsize=28)
xticks(arange(0,pi/2+.1,pi/4),('$0$','$\pi/4$','$\pi/2$'),fontsize=25)
ylabel("$1-P$",fontsize=28)
yscale('log',basex=10)
#yticks((0,-1,-2,-3),('$0$','$-1$','$-2$','$-3$'),fontsize=25)
yticks((.001,0.01,.1,1),('$10^{-3}$','$10^{-2}$','$10^{-1}$','$10^0$'),fontsize=25)

tick_params(axis='x',          # changes apply to the x-axis
    which='minor',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()