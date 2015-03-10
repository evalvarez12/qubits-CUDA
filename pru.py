#PARA PROBAR FUNCIONES ESPECIFICAS 

def bit_reflection_h(index,nqubits) :
    centro = nqubits/2 + (nqubits%2) - 1
    j=1
    res=0
    for i in range(nqubits):
        if (j&index!=0) :
            if(i<=centro) :
	      res+= j<<2*(centro-i) + (1 - nqubits%2)
	    else :
	      res+= j>>2*(i-centro) - (1 - nqubits%2)
        j=j<<1
        print res,j
    return res


