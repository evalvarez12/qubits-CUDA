from pylab import *

#./abc -o purity_gamma -q 17 --x 6 --model model3_open_VarMagnetic --Jc 0.01 --Jp 1. --Js 1. --DJs 0. --bx 1. --bz 1. --Dbs 0. --t 1000 --Cseed -1 --Eseed 3462 --PARAMseed 0  > VarMagnetic.dat

a=loadtxt("VarMagnetic.dat")
b=loadtxt("VarMagnetic2.dat")
c=loadtxt("VarMagnetic3.dat")
d=loadtxt("VarMagnetic4.dat")
i=sqrt(2)*linspace(0,2*pi,300)



plot(i,a,label='$\gamma=80\lambda$',linewidth=2)
plot(i,b,label='$\gamma=100\lambda$',linewidth=2)
plot(i,c,label='$\gamma=120\lambda$',linewidth=2)
plot(i,d,label='$\gamma=50\lambda$',linewidth=2)
xlabel("$|b|$",fontsize=17)
xticks((0,pi/2,pi,(3/2.)*pi,2*pi),('$0$','$\pi/2$','$\pi$','$3/2\pi$','$2\pi$','$\pi/\sqrt{2}$'),fontsize=17)
yticks((0.9,.91,.92,.88,.89),('$0.9$','$0.91$','$0.92$','$0.88$','$0.89$'),fontsize=17)
ylabel("$P$",fontsize=17)

legend(loc='upper right',fontsize=17)

axis([0,sqrt(2)*2*pi+.1,.85,.93])

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()