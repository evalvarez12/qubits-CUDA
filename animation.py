from pylab import *
from matplotlib import animation
from time import sleep

#animacion spectra* con J=1 DJs=0.1 bz=1 bx=[2,3]

#animacion spectra_dos_* con J=1 DJs=0.1 bx=1.4 bz=[0,1]


dists=[]


for i in range(100) :
  spectra=loadtxt("spectra/spectra_dos_"+str(i)+".dat")
  spectra=sort(spectra)
  dist=zeros(len(spectra))
  for i in range(len(spectra)-1) :
    dist[i]=abs(spectra[i]-spectra[i+1])
  dist[len(spectra)-1]=abs(spectra[0]-spectra[-1]+2*pi)  
  dist=dist/average(dist)
  dists.append(dist)


# First set up the figure, the axis, and the plot element we want to animate
fig = figure()
ax = axes(xlim=(0, 2*pi), ylim=(0, 3))
line, = ax.plot([],[],'ro-')
#line, = ax.hist([],50)


def goe(x) :
  return pi*x/2*exp(-pi*x**2/4)

def poiss(x) :
  return exp(-x)

ii=linspace(0,2*pi,200)
plot(ii,goe(ii))
plot(ii,poiss(ii))
xlabel('$s$')
ylabel('$P(s)$')
#hist(dist,50,range=(0,3),normed=True,histtype='step')



# initialization function: plot the background of each frame
def init():
    line.set_data([], [])
    return line,

# animation function.  This is called sequentially
#def animate(i):
    #x = np.linspace(0, 2, 1000)
    #y = np.sin(2 * np.pi * (x - 0.01 * i))
    #line.set_data(x, y)
    #return line,
    
def animate(i):
  sleep(0.1)
  print i
  y,x=histogram(dists[i],60,range=(0,2*pi),normed=True)
  x=x[:-1]
  line.set_data(x,y)
  #line.set_data(dists[i])
  return line,
  #j=arange(0,4,0.01)
  #plot(j,goe(j))
  #plot(j,poiss(j))
 
       

    

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
           frames=100, interval=1, blit=True)

#GUARDAT
mywriter = animation.FFMpegWriter()
anim.save('Ps_transition2.mp4', writer=mywriter)

show()