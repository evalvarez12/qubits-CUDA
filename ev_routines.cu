//DIFERENTE A EVCUDA EN CUDA.GIT
#ifndef EVCUDA
# define EVCUDA
# include "tools.cpp"
# include "cuda_functions.cu"
namespace evcuda{ 

void cmalloc(double** dev_R,double** dev_I,int l) {
  double *source_R;
  double *source_I;
  cudaMalloc((void**)&source_R,l*sizeof(double));
  cudaMalloc((void**)&source_I,l*sizeof(double));
  *dev_R=source_R;
  *dev_I=source_I;
  }


void itpp2cuda_malloc(itpp::cvec& state,double** dev_R,double** dev_I) { 
  int l=state.size();
  double *R=new double[l];
  double *I=new double[l];
  double *source_R;
  double *source_I;
  for(int i=0;i<l;i++) {
    R[i]=real(state(i));
    I[i]=imag(state(i));
    }
  
//   cudaMalloc((void**)&source_R,l*sizeof(double));
//   cudaMalloc((void**)&source_I,l*sizeof(double));
    
  cudaSafeCall(cudaMalloc((void**)&source_R,l*sizeof(double)),"malloc",0);
  cudaSafeCall(cudaMalloc((void**)&source_I,l*sizeof(double)),"malloc",0);
  
  //cout<<source_R<<" "<<source_I<<endl;

  cudaMemcpy(source_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
  cudaMemcpy(source_I,I,l*sizeof(double),cudaMemcpyHostToDevice);

  //cout<<dev_R<<" "<<dev_I<<endl;
  *dev_R=source_R;
  *dev_I=source_I;

  delete[] R;
  delete[] I;
  }
void itpp2cuda(itpp::cvec& state,double* dev_R,double* dev_I) { 
  int l=state.size();
  double *R=new double[l];
  double *I=new double[l];
  for(int i=0;i<l;i++) {
    R[i]=real(state(i));
    I[i]=imag(state(i));
    }

  cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
  cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);

  delete[] R;
  delete[] I;
  }
void cuda2itpp(itpp::cvec& state,double* dev_R,double* dev_I) { 
  int l=state.size();
  double *R=new double[l];
  double *I=new double[l];
  //cout<<dev_R<<" "<<dev_I<<endl;

  cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
  cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
  for(int i=0;i<l;i++) {
    state(i)=std::complex<double>(R[i],I[i]);
    }

  delete[] R;
  delete[] I;
  }

  

} 
#endif                                                    // EVCUDA
