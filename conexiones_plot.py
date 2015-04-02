from pylab import *

lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']


gammas2=[]
for i in range(1,15):
  gammas2+=[round(.75*(6./sqrt(double(i))),3)]

#gammas2=[.75,.75,.75,.75,.75,.75,.75,.75,.75,.75,.75,.75,.75,.75]


l=0
g=0
for i in range(1,15)  :
  a=loadtxt("pur_conexiones-max-2-"+str(i)+".dat")
  plot(a,lines[l],markevery=50,label="$"+str(i)+"$  $ \gamma= "+str(gammas2[g])+"$")
  g+=1
  l+=1


legend()
xlabel("$t$")
ylabel("$P$")
show()