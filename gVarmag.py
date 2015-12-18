from pylab import *

#./abc -o purity_gamma -q 17 --x 6 --model model3_open_VarMagnetic --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > VarMagnetic.dat

a=loadtxt("VarMagnetic.dat")
b=loadtxt("VarMagnetic2.dat")
c=loadtxt("VarMagnetic3.dat")
#d=loadtxt("VarMagnetic4.dat")
i=sqrt(2)*linspace(0,2*pi,300)

lines=['s-','<-','p-','v-','D-','H-','D-','h-','>-','H-','d-','x-','s-','+-']



plot(i,a,lines[0],label='$\gamma=80\lambda$',markersize=10,markevery=5)
plot(i,b,lines[1],label='$\gamma=100\lambda$',markersize=10,markevery=5)
plot(i,c,lines[2],label='$\gamma=120\lambda$',markersize=10,markevery=5)
#plot(i,d,lines[3],label='$\gamma=50\lambda$',markersize=10)
xlabel("$|b|$",fontsize=17)
xticks((0,pi/2,pi,(3/2.)*pi,2*pi),('$0$','$\pi/2$','$\pi$','$3/2\pi$','$2\pi$','$\pi/\sqrt{2}$'),fontsize=17)
yticks((0.9,.91,.92,.88,.89,.87,.86,.85),('$0.9$','$0.91$','$0.92$','$0.88$','$0.89$','$0.87$','$0.86$','$0.85$'),fontsize=17)
ylabel("$P$",fontsize=17)

legend(loc='upper right',fontsize=17)

axis([0,2*pi,.85,.93])

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()