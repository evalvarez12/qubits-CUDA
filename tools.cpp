#ifndef CUDATOOLS
#define CUDATOOLS

using namespace std;

void dec_bin(int a,int bin[],int num) {
  int res=0;
  for(int i=0;i<num;i++) {
    res=a%2;
    bin[i]=res;
    a=(a-res)/2;
  }
}


int bin_dec(int bin[],int num) {
  int dec=0;
  for(int i=0;i<num;i++) {
    dec=dec+(pow(2,i)*bin[i]);
  }
  return dec;
}

double* CNOT(double L[],int x, int y,int nqubits)  {
  int bin[nqubits];
  int l=pow(2,nqubits);
  double* CL=new double[l];
  for(int i=0;i<l;i++) {
    dec_bin(i,bin,nqubits);
    bin[y]=(bin[x]+bin[y])%2;
    int n=bin_dec(bin,nqubits);
    CL[n]=L[i];
  }
  return CL;
}

double* Hadamard(double L[],int x, int nqubits) {
  int bin[nqubits];
  int l=pow(2,nqubits);
  double* HL=new double[l];
  for(int i=0;i<l;i++) {
    dec_bin(i,bin,nqubits);
    if (bin[x]==0) {
      bin[x]=1;
      int n=bin_dec(bin,nqubits); 
      HL[i]=HL[i]+L[i];
      HL[n]=HL[n]+L[i];
    }
    if (bin[x]==1) {
      bin[0]=0;
      int n=bin_dec(bin,nqubits);
      double temp=(L[i]*(-1)); 
      HL[i]=HL[i]+(temp);
      HL[n]=HL[n]+L[i];
    }
  }
  for(int i=0;i<l;i++) {
    HL[i]=HL[i]*(1/sqrt(2));
  }
  return HL;
}

void randomstate(int length,double R[],double I[]) {
  double norm=0;
  srand(time(0));
  for(int i=0;i<length;i++) {
    std::complex<double> rand=itpp::randn_c();
    R[i]=real(rand);
    I[i]=imag(rand);
    norm=norm+pow(R[i],2)+pow(I[i],2);
  }
  norm=1/(sqrt(norm));
  for(int i=0;i<length;i++) {
    R[i]=R[i]*norm;
    I[i]=I[i]*norm;
  }
}


// void randomstate2d(int length,double R[],double I[]) {
//   double norm=0;
//   srand(time(0));
//   for(int i=0;i<length;i++) {
//     for(int k=0;k<length;k++) {
//       R[i][k]=rand()/double(RAND_MAX);
//       I[i][k]=rand()/double(RAND_MAX);
//       norm=norm+pow(R[i],2)+pow(I[i],2);
//     }
//   }
//   norm=1/(sqrt(norm));
//   for(int i=0;i<length;i++) {
//     for(int k=0;k<length;k++) {
//       R[i][k]=R[i][k]*norm;
//       I[i][k]=I[i][k]*norm;
//     }
//   }
// }

void exit_randomstate(int length,double R[],double I[]) {
  double norm=0;
  srand(time(0));
  ofstream datos;
  datos.open("/home/eduardo/infq/state.dat");
  for(int i=0;i<length;i++) {
    R[i]=rand()/double(RAND_MAX);
    I[i]=rand()/double(RAND_MAX);
    norm=norm+pow(R[i],2)+pow(I[i],2);
  }
  norm=1/(sqrt(norm));
  for(int i=0;i<length;i++) {
    R[i]=R[i]*norm;
    I[i]=I[i]*norm;
    datos << R[i] << " " << I[i] << endl;
  }
  datos.close();
}

void read_randomstate(int length,double R[],double I[]) {
  ifstream datos;
  datos.open("/home/eduardo/infq/state.dat");
  for(int i=0;i<length;i++) {
    datos >> R[i] >> I[i];
  }
}

int choosediv(int nqubits) { 
  if (nqubits > 24) { 
    return pow(2,nqubits-24);
  }
  else
    return 1;
}


void choosenumblocks(int l,int& numthreads,int& numblocks) {
  if (l>=512) {
    numthreads=512;
    if (l<pow(2,25)) {
      numblocks=l/numthreads;
    }
    else { 
      numblocks=32768;
    }
  }
  else {
    numthreads=l;
    numblocks=1;
  }
}

void alist(double A1[],double A2[],double B1[],double B2[],double Res1[],double Res2[],int a,int b) {
  for(int i=0;i<a;i++) {
    for(int k=0;k<b;k++) {
      Res1[(i*b)+k]=(A1[i]*B1[k])-(A2[i]*B2[k]);
      Res2[(i*b)+k]=(A1[i]*B2[k])+(A2[i]*B1[k]);
    }
  }
}

int numbits(int in) {
  int cont=0;
  for(int i=1;i<=in;i*=2) {
    if((i&in)==i) {
      cont++;
    }
  }
  return cont;
}

// void choosedivdens(int l,int& blocksdivdens,int& threadsdivdens) {
//   


void set_parameters(double ising,itpp::vec b,double& icos,double& isin, double& kcos,double& ksin,double& bx,double& by,double& bz) {
  icos=cos(ising);
  isin=sin(ising);
  double theta=itpp::norm(b);
  kcos=cos(theta);
  ksin=sin(theta);
  if (theta<0.000000000000001) {
    theta=1;
  }
  bx=b(0)/theta;
  by=b(1)/theta;
  bz=b(2)/theta;
}


void set_parameters(itpp::vec b,double& kcos,double& ksin,double& bx,double& by,double& bz) {
  double theta=itpp::norm(b);
  kcos=cos(theta);
  ksin=sin(theta);
  if (theta<0.000000000000001) {
    theta=1;
  }
  bx=b(0)/theta;
  by=b(1)/theta;
  bz=b(2)/theta;
}

void set_parameters(double ising,double& icos,double& isin) {
  icos=cos(ising);
  isin=sin(ising);
}

void set_parameters_trotter(double ising,itpp::vec b,double& icos,double& isin, double& kcos,double& ksin,double& bx,double& by,double& bz,double trotter) {
  double delta=1./trotter;
  icos=cos(delta*ising/2);
  isin=sin(delta*ising/2);
  double theta=delta*itpp::norm(b);
  kcos=cos(theta);
  ksin=sin(theta);
  if (theta<0.000000000000001) {
    theta=1;
  }
  bx=delta*b(0)/theta;
  by=delta*b(1)/theta;
  bz=delta*b(2)/theta;
}



int bit_rotation_h2(int index,int x,int nqubits) {
  int temp,comp,a,b,res=0;
  for(int i=0;i<nqubits;i+=x) {
    temp=0,comp=0;
    for(int j=0;j<x;j++) {
      temp+=index&(int)pow(2,i+j);
      comp+=(int)pow(2,i+j);
    }
    a=(temp<<1)&comp;
    b=(temp>>(x-1))&comp;
    res+= a+b;
  }
  return res;
}

int bit_rotation_v2(int index,int x,int nqubits) {
  int temp,comp,a,b,res=0;
  for(int i=0;i<x;i++) {
    temp=0,comp=0;
    for(int j=0;j<nqubits;j+=x) {
      temp+=index&(int)pow(2,i+j);
      comp+=(int)pow(2,i+j);
    }
    a=(temp<<x)&comp;
    b=(temp>>(nqubits-x))&comp;
    res+=a+b;
  }
  return res;
}

void find_states_horizontal(int A[],int nqubits,int xlen,int k,int l) {
  int j;
  int flag;
  for(int i=0;i<l;i++) {
    flag=0;
    if(A[i]!=0) {
      j=i;
      do {
	j=bit_rotation_h2(j,xlen,nqubits);
	A[j]=0;
	flag++;
      } while(j!=i);
      A[i]=1;
      if(flag==1 && k!=0) {
	A[i]=0;
      }
    }
  }
}

void find_states_vertical(int A[],int nqubits,int xlen,int k,int l) {
  int j;
  int flag;
  for(int i=0;i<l;i++) {
    flag=0;
    if(A[i]!=0) {
      j=i;
      do {
	j=bit_rotation_v2(j,xlen,nqubits);
	A[j]=0;
	flag++;
      } while(j!=i);
      A[i]=1;
      if(flag==1 && k!=0) {
	A[i]=0;
      }
    }
  }
}

// void find_states(int A[],int nqubits,int xlen,int kx,int ky,int l) {
//   int j,k;
//   int flag,flag2,flag3;
//   for(int i=0;i<l;i++) {
//     flag=0;
//     flag2=0;
//     flag3=0;
//     if(A[i]!=0) {
//       j=i;
//       do {
// 	j=bit_rotation_h2(j,xlen,nqubits);
// 	A[j]=0;
// 	flag++;
//       } while(j!=i);
//       j=bit_rotation_h2(i,xlen,nqubits);
//       k=i;
//       do {
// 	k=bit_rotation_v2(k,xlen,nqubits);
// 	A[k]=0;
// 	flag2++;
// 	if(k==j) {
// 	  flag3++; 
// 	}
//       } while(k!=i);
//       A[i]=1;
//       if(flag==1 && kx!=0) {
// 	A[i]=0;
//       }
//       if(flag2==1 && ky!=0) {
// 	A[i]=0;
//       }
//       if(flag3!=0 && kx!=ky) {
// 	A[i]=0;
//       }
//       if(A[i]==1) {
// 	cout<<i<<endl;
//       }
//     }
//   }
// }

void find_states(int A[],int nqubits,int xlen,int kx,int ky,int l) {
  int j,k;
  int flag,flag2;
  //   int flag,flag2,flag3;
  for(int i=0;i<l;i++) {
    flag=0;
    //     flag3=0;
    if(A[i]!=0) {
      j=i;
      do {
	k=j;
	flag2=0;
	do {
	  k=bit_rotation_v2(k,xlen,nqubits);
	  A[k]=0;
	  flag2++;
	} while(k!=j);
	j=bit_rotation_h2(j,xlen,nqubits);
	A[j]=0;
	flag++;
      } while(j!=i);
      j=i;
      for(int l=0;l<xlen-1;l++) {
	j=bit_rotation_h2(j,xlen,nqubits);
	k=i;
	// 	int dist=-1;
	for(int m=0;m<xlen-1;m++) {
	  k=bit_rotation_v2(k,xlen,nqubits);
	  // 	  if(j==k) {
	  // 	    flag3++;
	  // // 	    dist=m;
	  // 	  }
	}
      }
      A[i]=1;
      if(flag==1 && kx!=0) {
	A[i]=0;
	//cout<<"1"<<endl;
      }
      if(flag2==1 && ky!=0) {
	A[i]=0;
	//cout<<"2"<<endl;
      }
      //       if(flag3!=0 && (kx==dist || ky==dist)) {
      //       	A[i]=0;
      // 	cout<<"3"<<endl;
      //}
    }
  }
}

int count_bits_symx(int in,int nqubits) {
  int a=1;
  int total=0;
  for(int i=0;i<nqubits;i++) {
    total+=(in&a)/a;
    a=a<<1;
  }
  return pow(-1,total);
}



void find_states_take2_total(int A[],int nqubits,int xlen,int kx,int ky,int l,int symx) {
  int y=nqubits/xlen;
  int m,n,check;
  std::complex<double> sum;
  for(int i=0;i<l;i++) {
    if(A[i]!=0) {
      m=i;
      check=bit_rotation_h2(i,xlen,nqubits);
      sum=0.;
      for(int j=1;j<=xlen;j++) {
	m=bit_rotation_h2(m,xlen,nqubits);
	A[m]=0;
	n=m;
	for(int k=1;k<=y;k++) {
	  n=bit_rotation_v2(n,xlen,nqubits);
	  A[n]=0;
	  if(n==check) {
	    sum+=std::exp(std::complex<double>(0,2*itpp::pi*kx*j/xlen))*std::exp(std::complex<double>(0,2*itpp::pi*ky*k/y)); 
	  }
	} 
      }
      A[i]=1;
      if(count_bits_symx(i,nqubits)!=symx) {
	A[i]=0;
      }
      if(std::norm(sum)<1e-13) {
	A[i]=0;
      }
    }
  }
}

void find_states_take2_total(int A[],int nqubits,int xlen,int kx,int ky,int l) {
  int y=nqubits/xlen;
  int m,n,check;
  std::complex<double> sum;
  for(int i=0;i<l;i++) {
    if(A[i]!=0) {
      m=i;
      check=i;
      sum=0.;
      for(int j=1;j<=xlen;j++) {
	m=bit_rotation_h2(m,xlen,nqubits);
	A[m]=0;
	n=m;
	for(int k=1;k<=y;k++) {
	  n=bit_rotation_v2(n,xlen,nqubits);
	  A[n]=0;
	  if(n==check) {
	    sum+=std::exp(std::complex<double>(0,2*itpp::pi*kx*j/xlen))*std::exp(std::complex<double>(0,2*itpp::pi*ky*k/y));
	  }
	} 
      }
      A[i]=1;
      if(std::norm(sum)<1e-13) {
	A[i]=0;
      }
    }
  }
}



void find_states_total_horizontal(int A[],int nqubits,int kx,int l) {
  int m,check;
  std::complex<double> sum;
  for(int i=0;i<l;i++) {
    if(A[i]!=0) {
      m=i;
      check=i;
      sum=0.;
      for(int j=1;j<=nqubits;j++) {
	m=bit_rotation_h2(m,nqubits,nqubits);
	A[m]=0;
	if(m==check) {
	  sum+=std::exp(std::complex<double>(0,2*itpp::pi*kx*j/nqubits));
	}
      } 
      
      A[i]=1;
      if(std::norm(sum)<1e-13) {
	A[i]=0;
      }
    }
  }
}


int bit_reflection_h2(int index,int nqubits) {
  int centro = (nqubits/2 + (nqubits%2) - 1);
  int j=1;
  int res=0;
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

void find_states_reflection(int A[],int nqubits,int lambda,int l) {
  int m,check,sum;
  for(int i=0;i<l;i++) {
    if(A[i]!=0) {
      m=i;
      check=i;
      sum=0.;
      
      for(int j=0;j<2;j++) {
	m=bit_reflection_h2(m,nqubits);
	A[m]=0;
	if(m==check) {
	  sum+=pow(lambda,j);
	}
      } 
      A[i]=1;
      if(sum==0) {
	A[i]=0;
      }
    }
  }
}


double argument(complex<double> c) {
  double arg;
  if(real(c)>0) {
    if(imag(c)>=0) {
      arg=atan(imag(c)/real(c));
    }
    else {
      arg=atan(imag(c)/real(c))+2*itpp::pi;
    }
  }
  else {
    arg=atan(imag(c)/real(c))+itpp::pi;
  }
  return arg;
}


itpp::cvec tensor_prod(itpp::cvec a, itpp::cvec b) {
  int a_len = itpp::length(a);
  int b_len = itpp::length(b);
  itpp::cvec c(a_len*b_len);
  for(int i=0;i<a_len;i++) {
    for(int j=0;j<b_len;j++) {
      c(i*b_len+j)=a(i)*b(j);
    }
  }
  return c;
}
 
bool in(int a, itpp::ivec b) {
  for(int i=0;i<b.size();i++) {
    if (b(i)==a) {
      return true;
    }
  }
  return false;
}

itpp::imat conexiones(num,dima,dimb) {
  itpp::imat conex = itpp::zeros_i(dima,dimb);
  

  




#endif // CUDAITOOLS
