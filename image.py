from pylab import *
import matplotlib.colors

#s=raw_input()
#chain_cmap_0state2.dat
#obsx_plane.dat
a=loadtxt("color_map1_full.dat")

a=a.transpose()
#2 para correlaciones, 3 para desviaciones estandar
b=a[2]
b=b.reshape([250,250])
#c=flipud(b)
c=b.transpose()
#c=fliplr(c)
#c=zeros_like(b)


#title("Correlations ising="+str(double(s)/100)+" trotter 1g")
#title("Standard deviation ising=1.")
#imshow(c, origin='lower left',extent=[0,pi/2.,0,pi/4.],interpolation='bilinear')
axis([0,pi/2,0,pi/2])
imshow(c, origin='lower left',extent=[0,pi,0,pi])
xlabel("$b_x$")
ylabel("$b_z$")
colorbar()
show()


