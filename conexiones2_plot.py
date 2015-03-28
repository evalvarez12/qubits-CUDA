from pylab import *

a=loadtxt("pur_conexiones-2-10.dat")
b=loadtxt("pur_conexiones-2-20.dat")
c=loadtxt("pur_conexiones-2-20-2.dat")
d=loadtxt("pur_conexiones-2-20-3.dat")
e=loadtxt("pur_conexiones-2-20-4.dat")
f=loadtxt("pur_conexiones-2-20-7.dat")
g=loadtxt("pur_conexiones-2-20-5.dat")
h=loadtxt("pur_conexiones-2-20-6.dat")

plot(a,label="10 - $\gamma=0.1$")
plot(b,label="20 - $\gamma=0.1$")
plot(c,label="20 - $\gamma=0.5$")
plot(d,label="20 - $\gamma=1.0$")
plot(e,label="20 - $\gamma=2.0$")
plot(f,label="20 - $\gamma=0.05$")
plot(g,label="20 - $\gamma=0.01$")
plot(h,label="20 - $\lambda=0.001$")
legend()
xlabel("$t$")
ylabel("$P$")
axis([0,200,.48,1])
show()