#ifndef EVMATH
# define EVMATH
namespace evmath{

typedef void (*operador_evolucion)(double *, double *, itpp::vec, double, double, itpp::mat, int, int, itpp::ivec, itpp::ivec);

itpp::cmat evolution_matrix(operador_evolucion evolucion, itpp::vec js, double j, double jp, itpp::mat b ,  int nqubits, int extra, itpp::ivec A, itpp::ivec B)  {
  int l = pow(2,nqubits);
  double *dev_umatR,*dev_umatI;
  evcuda::cmalloc(&dev_umatR,&dev_umatI,l);
  int numthreads, numblocks;
  choosenumblocks(l,numthreads,numblocks);
  itpp::cvec state(l);
  itpp::cmat Umat(l,l);
  for(int i=0;i<l;i++) {
    index_one<<<numblocks,numthreads>>>(dev_umatR,dev_umatI,l,i);
    evolucion(dev_umatR,dev_umatI,js,j,jp,b,nqubits,extra,A,B);
    evcuda::cuda2itpp(state,dev_umatR,dev_umatI);
    Umat.set_col(i,state);
  }
  cudaFree(dev_umatR);
  cudaFree(dev_umatI);
  return Umat;
}

itpp::cmat evolution_matrix(operador_evolucion evolucion, itpp::vec js, double j, double jp, itpp::mat b ,  int nqubits, int extra, itpp::ivec A, itpp::ivec B, int symr)  { 
  //SECTORES DE SIMETRIA POR REFLEXION
  int l = pow(2,nqubits);
  double *dev_umatR,*dev_umatI;
  evcuda::cmalloc(&dev_umatR,&dev_umatI,l);
  
  int *S=new int[l];
  for(int m=0;m<l;m++) {
    S[m]=2;
  }
  find_states_reflection(S,nqubits,symr,l);
  int rcont=0;
  
  for(int i=0;i<l;i++) {
    if(S[i]==1) {
      S[rcont]=i;
      rcont++;
    }
  }
  
  int *dev_S;
  cudaMalloc((void**)&dev_S,rcont*sizeof(int)); 
  cudaMemcpy(dev_S,S,rcont*sizeof(int),cudaMemcpyHostToDevice);
  double *dev_dotR,*dev_dotI;
  evcuda::cmalloc(&dev_dotR,&dev_dotI,rcont);
  int numthreads, numblocks;
  choosenumblocks(l,numthreads,numblocks);
  
  itpp::cvec state(rcont);
  itpp::cmat Umat(rcont,rcont);
  for(int i=0;i<rcont;i++) {
    to_zero<<<numblocks,numthreads>>>(dev_umatR,dev_umatI,l); 
    reflection_proyector<<<1,1>>>(dev_umatR,dev_umatI,nqubits,symr,S[i]);
    times_norm<<<numblocks,numthreads>>>(dev_umatR,dev_umatI,l); 
  
    evolucion(dev_umatR,dev_umatI,js,j,jp,b,nqubits,extra,A,B);
   
    to_zero<<<numblocks,numthreads>>>(dev_dotR,dev_dotI,rcont); 
    proyected_dot_reflection<<<numblocks,numthreads>>>(dev_umatR,dev_umatI,dev_dotR,dev_dotI,nqubits,rcont,symr,dev_S);
    evcuda::cuda2itpp(state,dev_dotR,dev_dotI);
    
    Umat.set_col(i,state);
  }
  cudaFree(dev_umatR);
  cudaFree(dev_umatI);
  return Umat;
}


std::complex<double> purity_last_qubit(itpp::cvec state, int l) {
  itpp::cmat rho= itpp::zeros_c(2,2); 
  itpp::cvec a=state.right(l/2);
  itpp::cvec b=state.left(l/2); 
  
  rho(0,0)=itpp::dot(a,itpp::conj(a));
  rho(0,1)=itpp::dot(a,itpp::conj(b));
  rho(1,0)=itpp::dot(b,itpp::conj(a));
  rho(1,1)=itpp::dot(b,itpp::conj(b));
  rho=rho*rho;
  return itpp::trace(rho);
}

itpp::cmat reduced_densMat (double* dev_R, double* dev_I, int which, int nqubits) { 
  int ndens=pow(2,numbits(which));
  int l=pow(2,nqubits);
  double *densR=new double[ndens*ndens];
  double *densI=new double[ndens*ndens];
  double *dev_densR;      
  double *dev_densI;
  evcuda::cmalloc(&dev_densR,&dev_densI,ndens*ndens);
  cudaCheckError("dot",0);
  int numthreads, numblocks;
  choosenumblocks(l,numthreads,numblocks);
  to_zero<<<numthreads,numblocks>>>(dev_densR,dev_densI,ndens*ndens); 
  itpp::cmat densMat(ndens,ndens);
  //cout<<numblocks<<"  "<<numthreads/ndens<<endl;
  for(int i=0;i<ndens;i++) {
    for(int j=0;j<ndens;j++) {
      density_matrix<<<numblocks,numthreads>>>(which,ndens,i,j,dev_R,dev_I,dev_densR,dev_densI,l/ndens);
      cudaCheckError("dot",i+j);
    }
  }
  cudaMemcpy(densR,dev_densR,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost);
  cudaMemcpy(densI,dev_densI,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost);
  for(int i=0;i<ndens;i++) {
    for(int j=0;j<ndens;j++) {
      densMat(i,j)=std::complex<double>(densR[(ndens*i)+j],densI[(ndens*i)+j]);
    }
  }  
  cudaFree(dev_densR);
  cudaFree(dev_densI);
  return densMat;
}

void apply_sumdx(int nqubits,double* dev_R,double* dev_I,double* dev_sumdxR,double* dev_sumdxI) {
  int l=pow(nqubits,2);
  int numthreads;
  int numblocks;
  choosenumblocks(l,numthreads,numblocks); 
  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits,l);
  cudaCheckError("kick",10);
}

} 

#endif    