from pylab import *

a=loadtxt("pur_conexiones-2-1.dat")
b=loadtxt("pur_conexiones-2-2.dat")
c=loadtxt("pur_conexiones-2-3.dat")
d=loadtxt("pur_conexiones-2-4.dat")
e=loadtxt("pur_conexiones-2-5.dat")
f=loadtxt("pur_conexiones-2-6.dat")


plot(a)
plot(b)
plot(c)
plot(d)
plot(e)
plot(f,'s-',markevery=50)


legend()
xlabel("$t$")
ylabel("$P$")
show()