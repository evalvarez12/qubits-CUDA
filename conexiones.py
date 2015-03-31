from pylab import *


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
    while ((c in izq) or (c in der) or (c+1 in izq) or (c+1 in der) or (c-1 in izq) or (c-1 in der) or (c in conex[a])) :
      c=randint(dimb)
    conex[a]+=[c]
    num=num-1
  return conex



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
  