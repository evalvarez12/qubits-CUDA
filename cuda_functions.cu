#include "cu_complex.cu"

#ifndef CUDAFUNCTS
#define CUDAFUNCTS

__device__ double normed;


__device__ long long int ipow(int base,int exp) {
  int i=exp;
  long long int res=1;
  while (i>0) {
    res*=base;
    i--;
  }
  return res;
}

__device__ long long int bit_reflection_h(int index,int nqubits) {
  long long int centro = (nqubits/2 + (nqubits%2) - 1);
  long long int j=1;
  long long int res=0;
  for(int i=0;i<nqubits;i++) {
    if((j&index)!=0) {
      if(i<=centro) {
        res += j<<(2*(centro-i) + (1-nqubits%2));
      }
      else {
	res += j>>(2*(i-centro) - (1-nqubits%2));
      }
    }
    j=j<<1;
  }
  return res;
}

__device__ long long int bit_rotation_h(int index,int x,int nqubits) {
  long long int temp,comp,a,b,res=0;
  for(int i=0;i<nqubits;i+=x) {
    temp=0,comp=0;
    for(int j=0;j<x;j++) {
      temp+=index&ipow(2,i+j);
      comp+=ipow(2,i+j);
    }
    a=(temp<<1)&comp;
    b=(temp>>(x-1))&comp;
    res+= a+b;
  }
  return res;
}


__device__ long long int bit_rotation_v(int index,int x,int nqubits) {
  long long int temp,comp,a,b,res=0;
  for(int i=0;i<x;i++) {
    temp=0,comp=0;
    for(int j=0;j<nqubits;j+=x) {
      temp+=index&ipow(2,i+j);
      comp+=ipow(2,i+j);
    }
    a=(temp<<x)&comp;
    b=(temp>>(nqubits-x))&comp;
    res+=a+b;
  }
  return res;
}


__device__  long long int trans(int index,int which,int where) {
  int i=1,cont=1,a,res=0;
  long long int warped=index;
  do { 
    if((i&which)==i) {
      a=(cont&where)/cont;
      cont*=2;
      res+=i*a;
      warped=warped<<1;
    } 
    if((i&warped)==i) {
      res+=i;
      warped-=i;
    }
    i*=2;
  } while(i<=warped || i<=which);
  return res;
}



__device__ void remove_zeros(int which,int in,int res) {
  int i=0;
  int cont=0;
  do {
    if (i|which==which) {
      if (i|in==in) {
	res+=ipow(2,cont);
      }
      cont++;
    }
    i++;
  } while (i!=which);
}

__global__ void vertical_rotation(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int n=1) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  while (index<l) {
    index2=index;
    for(int i=0;i<n;i++) {
      index2=bit_rotation_v(index2,x,nqubits);
    }
    rotR[index2]=R[index];
    rotI[index2]=I[index];
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void horizontal_rotation(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int n=1) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  while (index<l) {
    index2=index;
    for(int i=0;i<n;i++) {
      index2=bit_rotation_h(index2,x,nqubits);
    }
    rotR[index2]=R[index];
    rotI[index2]=I[index];
    index +=blockDim.x*gridDim.x;
  }
}





__global__ void horizontal_proyector(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int k) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  while (index<l) {
    index2=index;
    rotR[index]=R[index];
    rotI[index]=I[index];
    for(int i=1;i<x;i++) {
      index2=bit_rotation_h(index2,x,nqubits);
      rotR[index]=rotR[index]+cospi((2.*k*i)/x)*R[index2]-sinpi((2.*k*i)/x)*I[index2];
      rotI[index]=rotI[index]+sinpi((2.*k*i)/x)*R[index2]+cospi((2.*k*i)/x)*I[index2];
    }
    rotR[index]=rotR[index];
    rotI[index]=rotI[index];
    index +=blockDim.x*gridDim.x;
  }
  
}


__global__ void vertical_proyector(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int k) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  int y=nqubits/x;
  while (index<l) {
    index2=index;
    rotR[index]=R[index];
    rotI[index]=I[index];
    for(int i=1;i<y;i++) {
      index2=bit_rotation_v(index2,x,nqubits);
      rotR[index]=rotR[index]+cospi((2.*k*i)/y)*R[index2]-sinpi((2.*k*i)/y)*I[index2];
      rotI[index]=rotI[index]+sinpi((2.*k*i)/y)*R[index2]+cospi((2.*k*i)/y)*I[index2];
    }
    rotR[index]=rotR[index];
    rotI[index]=rotI[index];
    index +=blockDim.x*gridDim.x;
  }
  
}

__global__ void both_proyector(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int kx,int ky) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  int y=nqubits/x;
  double cx,cy,sx,sy;
  while (index<l) {
    index2=index;
    for(int i=1;i<=x;i++) {
      index2=bit_rotation_h(index2,x,nqubits);
      cx=cospi((2.*kx*i)/double(x));
      sx=sinpi((2.*kx*i)/double(x));
      for(int j=1;j<=y;j++) {
	index2=bit_rotation_v(index2,x,nqubits);
	cy=cospi((2.*ky*j)/double(y));
	sy=sinpi((2.*ky*j)/double(y));
	rotR[index]+=(cx*cy-sx*sy)*R[index2]-(cx*sy+cy*sx)*I[index2];
	rotI[index]+=(cx*sy+cy*sx)*R[index2]+(cx*cy-sx*sy)*I[index2];
      }
    }
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void special_both_proyector(double R[],double I[],int x,int nqubits,int l,int kx,int ky,int S) {
  long long int index2;
  int y=nqubits/x;
  double cx,cy,sx,sy;
  index2=S;
  int norm=0;
  for(int i=1;i<=x;i++) {
    index2=bit_rotation_h(index2,x,nqubits);
    cx=cospi((2.*kx*i)/double(x));
    sx=sinpi((2.*kx*i)/double(x));
    for(int j=1;j<=y;j++) {
      index2=bit_rotation_v(index2,x,nqubits);
      cy=cospi((2.*ky*j)/double(y));
      sy=sinpi((2.*ky*j)/double(y));
      R[index2]+=(cx*cy-sx*sy);
      I[index2]+=(cx*sy+cy*sx);
      if (index2==S) {
	norm++;
      }
    }
  }
  normed=1./sqrt(double(nqubits*norm));
}

__global__ void special_chain_proyector(double R[],double I[],int nqubits,int l,int kx,int S) {
  long long int index2;
  double cx,sx;
  index2=S;
  int norm=0;
  for(int i=1;i<=nqubits;i++) {
    index2=bit_rotation_h(index2,nqubits,nqubits);
    cx=cospi((2.*kx*i)/double(nqubits));
    sx=sinpi((2.*kx*i)/double(nqubits));
    R[index2]+=cx;
    I[index2]+=sx;
    if (index2==S) {
      norm++;
    }
  }
  
  normed=1./sqrt(double(nqubits*norm));
}

__global__ void reflection_proyector(double R[],double I[],int nqubits,int lambda,int S) {
  long long int index2;
  index2=S;
  int norm=1;
  R[index2]=1;
  index2=bit_reflection_h(index2,nqubits);
  R[index2]=lambda*1;
  if (index2==S) {
    norm++;
  }
  normed=1./sqrt(2./double(norm));
}

__global__ void special_both_proyector(double R[],double I[],int x,int nqubits,int l,int kx,int ky,int S,double sr,double si) {
  //checar el signo de la parte imaginaria
  long long int index2;
  int y=nqubits/x;
  double cx,cy,sx,sy;
  index2=S;
  int norm=0;
  for(int i=1;i<=x;i++) {
    index2=bit_rotation_h(index2,x,nqubits);
    cx=cospi((2.*kx*i)/double(x));
    sx=sinpi((2.*kx*i)/double(x));
    for(int j=1;j<=y;j++) {
      index2=bit_rotation_v(index2,x,nqubits);
      cy=cospi((2.*ky*j)/double(y));
      sy=sinpi((2.*ky*j)/double(y));
      R[index2]+=(cx*cy-sx*sy)*sr-(cx*sy+cy*sx)*si;
      I[index2]+=(cx*sy+cy*sx)*sr+(cx*cy-sx*sy)*si;
      if (index2==S) {
	norm++;
      }
    }
  }
  normed=1./sqrt(double(norm));
}


__global__ void proyected_dot(double R[],double I[],double rotR[],double rotI[],int x,int nqubits,int l,int kx,int ky, int S[]) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  //   long long int index2,norm;
  int y=nqubits/x;
  //   int i,j;
  while (index<l) {
    double cx,cy,sx,sy;
    index2=S[index];
    int norm=0;
    for(int i=1;i<=x;i++) {
      index2=bit_rotation_h(index2,x,nqubits);
      cx=cospi((2.*kx*i)/double(x));
      sx=sinpi((2.*kx*i)/double(x));
      for(int j=1;j<=y;j++) {
	index2=bit_rotation_v(index2,x,nqubits);
	cy=cospi((2.*ky*j)/double(y));
	sy=sinpi((2.*ky*j)/double(y));
	rotR[index]=rotR[index]+(cx*cy-sx*sy)*R[index2]-(cx*sy+cy*sx)*I[index2];
	rotI[index]=rotI[index]+(cx*sy+cy*sx)*R[index2]+(cx*cy-sx*sy)*I[index2];
	if (index2==S[index]) {
	  norm++;
	}
      }
    }
    rotR[index]=rotR[index]/sqrt(double(nqubits*norm));
    rotI[index]=rotI[index]/sqrt(double(nqubits*norm));
    index +=blockDim.x*gridDim.x;
  }
  
}


__global__ void proyected_dot_chain(double R[],double I[],double rotR[],double rotI[],int nqubits,int l,int kx,int S[]) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  //   long long int index2,norm;
  
  //   int i,j;
  while (index<l) {
    double cx,sx;
    index2=S[index];
    int norm=0;
    for(int i=1;i<=nqubits;i++) {
      index2=bit_rotation_h(index2,nqubits,nqubits);
      cx=cospi((2.*kx*i)/double(nqubits));
      sx=sinpi((2.*kx*i)/double(nqubits));
      rotR[index]=rotR[index]+(cx)*R[index2]-(sx)*I[index2];
      rotI[index]=rotI[index]+(sx)*R[index2]+(cx)*I[index2];
      if (index2==S[index]) {
	norm++;
      }
      
    }
    rotR[index]=rotR[index]/sqrt(double(nqubits*norm));
    rotI[index]=rotI[index]/sqrt(double(nqubits*norm));
    index +=blockDim.x*gridDim.x;
  }
  
}

__global__ void proyected_dot_reflection(double R[],double I[],double rotR[],double rotI[],int nqubits,int l,int lambda,int S[]) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int index2;
  //   long long int index2,norm;
  
  //   int i,j;
  while (index<l) {
    index2=S[index];
    int norm=1;
    rotR[index]+= R[index2];
    rotI[index]+= I[index2];
    index2=bit_reflection_h(index2,nqubits);
    rotR[index]+= lambda*R[index2];
    rotI[index]+= lambda*I[index2];
    if (index2==S[index]) {
      norm++;
    }   
    rotR[index]=rotR[index]/sqrt(2./double(norm));
    rotI[index]=rotI[index]/sqrt(2./double(norm));
    index +=blockDim.x*gridDim.x;
  } 
}


__global__ void dev_sum(int l,double R1[],double I1[],double R2[], double I2[]) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (index<l) {
    R1[index]+=R2[index];
    I1[index]+=I2[index];
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void Ui_kernel(int n,int m,double R[],double I[],double mcos,double msin,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int in=1<<n;
  long long int im=1<<m;
  while (index<l) {
    Complex i(0,1);
    Complex a=Complex(R[index],I[index])*mcos;
    int sigz=(((index&in)/in)+((index&im)/im))%2;
    Complex b=Complex(R[index],I[index])*ipow(-1,sigz)*msin;
    b=b*i;
    R[index]=(a-b).real;
    I[index]=(a-b).imag;
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void Uk_kernel(int k,double R[],double I[],double bx,double by,double bz,double mcos,double msin,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2=1<<k;
  Complex i(0,1);
  while (index<l) {
    //bitwise aqui
    //no tiene a i2
    if ((index&i2)==0) {
      Complex a=Complex(R[index],I[index])*mcos;
      Complex b=Complex(R[index],I[index])*bz;
      Complex c=Complex(R[index+i2],I[index+i2])*bx;
      Complex d=Complex(R[index+i2],I[index+i2])*by*-1;
      d=d*i;
      b=b+c+d;
      b=(b*i)*msin;
      Complex a2=Complex(R[index+i2],I[index+i2])*mcos;
      Complex b2=Complex(R[index+i2],I[index+i2])*bz*-1;
      Complex c2=Complex(R[index],I[index])*bx;
      Complex d2=Complex(R[index],I[index])*by;
      d2=d2*i;
      b2=b2+c2+d2;
      b2=(b2*i)*msin;
      R[index]=(a-b).real;
      I[index]=(a-b).imag;
      R[index+i2]=(a2-b2).real;
      I[index+i2]=(a2-b2).imag;
    }
    index+=blockDim.x*gridDim.x;
  }
}

__global__ void sigma_x(double R[],double I[],double sumdxR[],double sumdxI[],int i,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2;
  while (index<l) {
    i2=ipow(2,i);
    sumdxR[index]=R[index+i2*ipow(-1,(index&i2)/i2)];
    sumdxI[index]=I[index+i2*ipow(-1,(index&i2)/i2)];
    
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void sigma_xsigma_y(double R[],double I[],double sumdxR[],double sumdxI[],int i,int j,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2,i3;
  while (index<l) {
    i2=ipow(2,i);
    i3=ipow(2,j);
    sumdxR[index]=R[index+i2*ipow(-1,(index&i2)/i2)]+ipow(-1,(index&i3)/i3+2)*I[index+i3*ipow(-1,(index&i3)/i3)];
    sumdxI[index]=I[index+i2*ipow(-1,(index&i2)/i2)]+ipow(-1,(index&i3)/i3+1)*R[index+i3*ipow(-1,(index&i3)/i3)];
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void sumsigma_x(double R[],double I[],double sumdxR[],double sumdxI[],int nqubits,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2;
  while (index<l) {
    int i=0;
    sumdxR[index]=0.;
    sumdxI[index]=0.;
    while (i<nqubits) {
      i2=ipow(2,i);
      sumdxR[index]+=R[index+i2*ipow(-1,(index&i2)/i2)];
      sumdxI[index]+=I[index+i2*ipow(-1,(index&i2)/i2)];
      i++;
    }
    index +=blockDim.x*gridDim.x;
  }
}


__global__ void sumsigma_z(double R[],double I[],double sumdzR[],double sumdzI[],int nqubits,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2;
  while (index<l) {
    int i=0;
    sumdzR[index]=0.;
    sumdzI[index]=0.;
    while (i<nqubits) {
      i2=ipow(2,i);
      sumdzR[index]+=ipow(-1,(index&i2)/i2);
      sumdzI[index]+=ipow(-1,(index&i2)/i2);
      i++;
    }
    sumdzR[index]*=R[index];
    sumdzI[index]*=I[index];
    index +=blockDim.x*gridDim.x;
  }
}


__global__ void sumsigma_y(double R[],double I[],double sumdyR[],double sumdyI[],int nqubits,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2;
  while (index<l) {
    int i=0;
    sumdyR[index]=0.;
    sumdyI[index]=0.;
    while (i<nqubits) {
      i2=ipow(2,i);
      sumdyR[index]+=ipow(-1,(index&i2)/i2+2)*I[index+i2*ipow(-1,(index&i2)/i2)];
      sumdyI[index]+=ipow(-1,(index&i2)/i2+1)*R[index+i2*ipow(-1,(index&i2)/i2)];
      i++;
    }
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void prodsigma_x(double R[],double I[],double sumdxR[],double sumdxI[],int nqubits,int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  long long int i2;
  while (index<l) {
    int i=0;
    sumdxR[index]=1.;
    sumdxI[index]=1.;
    while (i<nqubits) {
      i2=ipow(2,i);
      sumdxR[index]=(R[index+i2*ipow(-1,(index/i2)%2)]*sumdxR[index])-(I[index+i2*ipow(-1,(index/i2)%2)]*sumdxI[index]);
      sumdxI[index]=(I[index+i2*ipow(-1,(index/i2)%2)]*sumdxR[index])+(R[index+i2*ipow(-1,(index/i2)%2)]*sumdxI[index]);
      i++;
    }
    index +=blockDim.x*gridDim.x;
  }
}



__device__ void matomicAdd(double* address, double val) {
  unsigned long long int* address_as_ull =
  (unsigned long long int*)address;
  unsigned long long int old = *address_as_ull, assumed;
//   do {
//     assumed = old;
//     old = atomicCAS(address_as_ull, assumed,__double_as_longlong(val +__longlong_as_double(assumed)));
//   } while (assumed != old);
  // return __longlong_as_double(old);
}



__global__ void QFT(int k,double R[],double I[],int l,int nqubits) {
  int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (((index/__float2int_rz(__powf(2,k)))%2==0) && (index<l)) {
    int i2=__float2int_rz(__powf(2,k));
    double x=R[index];
    double y=I[index];
    R[index]=(R[index]+R[index+i2])*(1/sqrtf(2));
    I[index]=(I[index]+I[index+i2])*(1/sqrtf(2));
    R[index+i2]=(x-R[index+i2])*(1/sqrtf(2));
    I[index+i2]=(y-I[index+i2])*(1/sqrtf(2));
    for(int i=k+1;i<nqubits;i++) {
      if((index/__float2int_rz(__powf(2,i)))%2==1) {
	Complex a=Complex(R[index+i2],I[index+i2]);
	Complex b=Complex(cosf(2*3.141592654f/__powf(2,i)),sinf(2*3.141592654f/__powf(2,i)));
	a=a*b;
	R[index+i2]=a.real;
	I[index+i2]=a.imag;
      }
    }
    index +=blockDim.x*gridDim.x;
  }
}




__global__ void density_matrix(int which,int ndim,int tarjet1,int tarjet2,double R[],double I[],double densR[],double densI[],int l) {
  int index=threadIdx.x+blockIdx.x*blockDim.x;
  __shared__ Complex cache[512];
  Complex temp=Complex(0,0);
  int cacheindex=threadIdx.x;
  int i1,i2;
  
  while (index<l) {
    i1=trans(index,which,tarjet1);
    i2=trans(index,which,tarjet2);
    Complex a=Complex(R[i1],I[i1]);
    Complex b=Complex(R[i2],(-1)*I[i2]);
    a=(a*b);
    temp=temp+a;
    index+=blockDim.x*gridDim.x;
  }
  cache[cacheindex]=temp;
  __syncthreads();
  
  
  int n = blockDim.x/2;
  while (n != 0) {
    if (cacheindex < n) {
      cache[cacheindex] = cache[cacheindex] + cache[cacheindex + n];
    }
    __syncthreads();
    n /= 2;
  }
  if (cacheindex==0) {
    matomicAdd(&densR[(tarjet1*ndim)+tarjet2],cache[0].real);
    matomicAdd(&densI[(tarjet1*ndim)+tarjet2],cache[0].imag);
  }
}

//revisar shared cache  
__global__ void timed_dot(int time,double AR[],double AI[],double BR[],double BI[],double resR[],double resI[],int l) {
  int index=threadIdx.x+blockIdx.x*blockDim.x;
  //__shared__ Complex cache;
  Complex temp=Complex(0,0);
  int cacheindex=threadIdx.x;
  
  while (index<l) {
    Complex a=Complex(AR[index],AI[index]);
    Complex b=Complex(BR[index],(-1)*BI[index]);
    a=(a*b);
    temp=temp+a;
    index+=blockDim.x*gridDim.x;
  }
  //cache=temp;
  __syncthreads();
  
  
  int n = blockDim.x/2;
  while (n != 0) {
    if (cacheindex < n) {
      //cache[cacheindex] = cache[cacheindex] + cache[cacheindex + n];
    }
    __syncthreads();
    n /= 2;
  }
  //   if (cacheindex==0) {
  //     matomicAdd(&resR[time],cache.real);  
  //     matomicAdd(&resI[time],cache.imag);
  //   }
}

__global__ void to_zero(double A[],double B[],int l) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (index<l) {
    A[index]=0.;
    B[index]=0.;
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void index_one(double A[],double B[],int l,int in) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (index<l) {
    A[index]=0.;
    B[index]=0.;
    if(index==in) {
      A[index]=1.;
    }
    index +=blockDim.x*gridDim.x;
  }
}



__global__ void devcpy(int l,double A1[],double A2[],double B1[],double B2[]) {
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (index<l) {
    B1[index]=A1[index];
    B2[index]=A2[index];
    index +=blockDim.x*gridDim.x;
  }
}

__global__ void times_norm(double A[],double B[],int l) {
  //VER SI AQUI VA LA CONGUDADA
  long long int index=threadIdx.x + blockIdx.x * blockDim.x;
  while (index<l) {
    A[index]=A[index]*normed;
    B[index]=B[index]*normed;
    index +=blockDim.x*gridDim.x;
  }
}



#endif
