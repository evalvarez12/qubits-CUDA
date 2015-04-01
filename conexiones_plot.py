from pylab import *

lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']

gammas=[.6,.3,.2,.15,.12,.1,.08,.075,.067,.06,.055,.05,.046,0.043]

l=0
g=0
for i in range(1,15)  :
  a=loadtxt("pur_conexiones-4-"+str(i)+".dat")
  plot(a,lines[l],markevery=50,label="$"+str(i)+"$  $ \gamma= "+str(gammas[g])+"$")
  g+=1
  l+=1


legend()
xlabel("$t$")
ylabel("$P$")
show()