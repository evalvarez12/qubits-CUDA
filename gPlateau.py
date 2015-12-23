from pylab import *

#./abc -o purity_gamma -q 17 --x 6 --model model3_open_VarMagnetic --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > VarMagnetic.dat

a=loadtxt("plateau1.dat")
b=loadtxt("plateau2.dat")
c=loadtxt("plateau3_pi.dat")
d=loadtxt("plateau4_pi2.dat")



i=linspace(0,pi,151)

lines=['s-','<-','p-','v-','D-','H-','D-','h-','>-','H-','d-','x-','s-','+-']


fig=figure(figsize=(9.8, 6.8)) # in inches!

plot(i,a,lines[0],label=r'$|\vec{b}|=2.2$',markersize=10,markevery=2)
plot(i,b,lines[1],label=r'$|\vec{b}|=1.1$',markersize=10,markevery=2)
plot(i,c,lines[2],label=r'$|\vec{b}|=\pi$',markersize=10,markevery=2)
plot(i,d,lines[3],label=r'$|\vec{b}|=\pi/2$',markersize=10)

xlabel(r"$\gamma$",fontsize=17)
xticks((0,pi/2,pi,(3/2.)*pi,2*pi),('$0$','$\pi/2$','$\pi$','$3/2\pi$','$2\pi$','$\pi/\sqrt{2}$'),fontsize=17)
#yticks((0.86,.87,.88,.89,.90,.91,.92),('$0.86$','$0.87$','$0.88$','$0.89$','$0.90$','$0.91$','$0.92$'),fontsize=17)
yticks((1,0.9,0.8,0.7,0.6,0.5),('$1$','$0.9$','$0.8$','$0.7$','$0.6$','$0.5$'),fontsize=17)
ylabel("$P$",fontsize=17)

legend(loc='upper right',fontsize=17)

axis([0,pi,.5,1])

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


savefig('Plateau.png')