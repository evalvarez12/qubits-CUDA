from pylab import *

lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']




jps=linspace(0,pi/2,150)

l=0
g=0
for i in range(1,6)  :
  a=loadtxt("maxpur-randconex-11-"+str(i)+".dat")
  plot(jps,a,lines[l],markevery=2,label="$"+str(i)+"$")
  g+=1
  l+=1
  
  

a=loadtxt("maxpur-11.dat")
plot(jps,a,'d-',markevery=2,label="$COMPLETE$")

text(1.3,0.7,'$\lambda=0.01$',fontsize=18)
#axis([0,pi/2,.48,1.05])
legend(loc='upper left')
xlabel("$\gamma$")
ylabel("$P$")
show()