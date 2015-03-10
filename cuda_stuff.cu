#include "cu_complex.cu"

__global__ void dot_split(int i,int j,int split,double R[],double I[],double parR[],double parI[],int l) {
  int index=threadIdx.x + blockIdx.x * blockDim.x;
  __shared__ Complex cache[512];
  int cacheindex=threadIdx.x;
  
  Complex temp;
  while(index<l/split) {
    Complex a=Complex(R[(l/split)*i+index],I[(l/split)*i+index]);
    Complex b=Complex(R[(l/split)*j+index],(-1)*I[(l/split)*j+index]);
    a=(a*b);
    temp= temp+a;
    index +=blockDim.x*gridDim.x;
  }
  
  cache[cacheindex]=temp;
  __syncthreads();
  
  int n = blockDim.x/2;
  while (n != 0) {
    if (cacheindex < n)
      cache[cacheindex] = cache[cacheindex] + cache[cacheindex + n];
    __syncthreads();
    n /= 2;
  }
  if (cacheindex==0) {
    parR[blockIdx.x]=cache[0].real;
    parI[blockIdx.x]=cache[0].imag;
  }
}

__global__ void dot_1(int i,int j,int q,double R[],double I[],double parR[],double parI[],int l) {
  int index=threadIdx.x + blockIdx.x * blockDim.x;
  __shared__ Complex cache[512];
   int cacheindex=threadIdx.x;
  
  
  Complex temp=Complex(0,0);
  while (((index/__float2int_rz(powf(2,q)))%2==0) && (index<l)) {
    int i2=__float2int_rz(powf(2,q));
    Complex a=Complex(R[index+i*i2],I[index+i*i2]);
    Complex b=Complex(R[index+j*i2],(-1)*I[index+j*i2]);
    a=(a*b);
    temp= temp+a;
    index +=blockDim.x*gridDim.x;
  }
  
  cache[cacheindex]=temp;
  __syncthreads();
  
  int n = blockDim.x/2;
  while (n != 0) {
    if (cacheindex < n)
      cache[cacheindex] = cache[cacheindex] + cache[cacheindex + n];
    __syncthreads();
    n /= 2;
  }
  if (cacheindex==0) {
    parR[blockIdx.x]=cache[0].real;
    parI[blockIdx.x]=cache[0].imag;
  }
}


__global__ void dot_2(int i,int j,int q,double R[],double I[],double dotR[],double dotI[],int l) {
  int index=threadIdx.x + blockIdx.x * blockDim.x;
  __shared__ Complex cache[512];
   int cacheindex=threadIdx.x;
  
  
  Complex temp=Complex(0,0);
  while (index<l) {
    if ((index/__float2int_rz(__powf(2,q)))%2==0) {
      int i2=__float2int_rz(powf(2,q));
      Complex a=Complex(R[index+i*i2],I[index+i*i2]);
      Complex b=Complex(R[index+j*i2],(-1)*I[index+j*i2]);
      a=(a*b);
      temp= temp+a;
    }
    index +=blockDim.x*gridDim.x;
  }
  
  cache[cacheindex]=temp;
  __syncthreads();
  
  int n = blockDim.x/2;
  while (n != 0) {
    if (cacheindex < n)
      cache[cacheindex] = cache[cacheindex] + cache[cacheindex + n];
    __syncthreads();
    n /= 2;
  }
  if (cacheindex==0) {
    matomicAdd(&dotR[q],cache[0].real);
    matomicAdd(&dotI[q],cache[0].imag);
  }
}


__global__ void density_matrix2(int which,int ndim,double R[],double I[],double densR[],double densI[],int l) {
  int index=threadIdx.x+blockIdx.x*blockDim.x;
  int i=0;
  int res,cont,i2;
  while (index<l) {
    res=0;
    cont=0;
    remove_zeros(which,index,res);
    do {
      if (i|which==which) {
	i2=i-index&which;
	Complex b=Complex(R[i2],I[i2]);
	Complex a=Complex(R[index],I[index])*b;	
	matomicAdd(&densR[res*ndim+cont],a.real);
	matomicAdd(&densI[res*ndim+cont],a.imag);
      }
      i++;
      cont++;
    } while (i!=which);
    index +=blockDim.x*gridDim.x;
  }
}

