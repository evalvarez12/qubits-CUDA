from pylab import *


a=loadtxt("deltaZ.dat")
i=linspace(0,2*pi,300)


plot(i,a,label='$\gamma=80\lambda$',linewidth=2)

#xlabel("$\delta_z$",fontsize=17)
#xticks((0,pi/2,pi,(3/2.)*pi,2*pi),('$0$','$\pi/2$','$\pi$','$3/2\pi$','$2\pi$','$\pi/\sqrt{2}$'),fontsize=17)
#yticks((0.9,.91,.92,.88,.89),('$0.9$','$0.91$','$0.92$','$0.88$','$0.89$'),fontsize=17)
#ylabel("$P$",fontsize=17)

#legend(loc='upper right',fontsize=17)

#axis([0,2*pi,.5,.9])

tick_params(axis='both',          # changes apply to the x-axis
    which='both',      # both major and minor ticks are affected
    bottom='on',      # ticks along the bottom edge are off
    top='on',         # ticks along the top edge are off
    labelbottom='on',
    length=10)


show()