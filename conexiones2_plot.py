from pylab import *

#lines=['o-','<-','p-','v-','*-','^-','D-','h-','>-','H-','d-','x-','s-','+-']

#gammas=[.6,.3,.2,.15,.12,.1,.08,.075,.067,.06,.055,.05,.046,0.043]
#gammas=sqrt(gammas)
#gammas2=[]
#for i in gammas:
 # gammas2+=[round(i,3)]


#l=0
#g=0
for i in range(1,6)  :
  a=loadtxt("pur_conexiones-2-2-"+str(i)+".dat")
  plot(a)

a=loadtxt("pur_conexiones-2-2-6.dat")
plot(a,'D-',markevery=50)  
  


legend()
axis([0,2500,0.5,1])
xlabel("$t$")
ylabel("$P$")
show()