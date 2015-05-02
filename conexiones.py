from pylab import *
from numpy import *


def conexiones(numero_total,dima,dimb) :
  conex=[]
  for i in range(dima):
    conex.append([])
  num=numero_total
  a=0
  while(num>0) :
    c=randint(dimb)
    a=randint(dima)
    aizq=a-1
    ader=a+1
    if (a==dima-1) :
      ader=aizq
    if (a==0) :
      aizq=ader
    izq=conex[aizq]
    der=conex[ader]
    cont=0
    while ((c in izq) or (c in der) or (c+1 in izq) or (c+1 in der) or (c-1 in izq) or (c-1 in der) or (c in conex[a])) :
      c=randint(dimb)
      cont+=1
      if (cont==500) :
	a=randint(dima)
	aizq=a-1
	ader=a+1
	if (a==dima-1) :
	  ader=aizq
	if (a==0) :
	  aizq=ader
	izq=conex[aizq]
	der=conex[ader]
	cont=0
    conex[a]+=[c]
    num=num-1
  return conex

def to_mat(vec,num,dima,dimb) :
  mat=zeros((num+1,2),dtype=int)
  mat[0][0]=num
  mat[0][1]=0
  k=1
  for i in range(dima) :
    for j in vec[i] :
      mat[k][0]=i
      mat[k][1]=j+dima
      k+=1
  return mat




def set_conexiones(num,dima,dimb) :
  a = to_mat(conexiones(num,dima,dimb),num,dima,dimb)
  savetxt('conexiones.txt', a,fmt='%u')

    

#numero_total=10
#dima=6
#dimb=10

##conex=[]
##for i in range(dima):
  ##conex.append([])
##num=numero_total
##a=0
##while(num>0) :
  ##c=randint(dimb)
  ##a=randint(dima)
  ##aizq=a-1
  ##ader=a+1
  ##if (a==dima-1) :
    ##ader=aizq
  ##if (a==0) :
    ##aizq=ader
  ##izq=conex[aizq]
  ##der=conex[ader]
  ##while ((c in izq) or (c in der) or (c+1 in izq) or (c+1 in der) or (c-1 in izq) or (c-1 in der) or (c in conex[a])) :
    ##c=randint(dimb)
  ##conex[a]+=[c]
  ##num=num-1
  