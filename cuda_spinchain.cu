// Includes {{{
#include <iostream>
#include <itpp/itbase.h>
#include <spinchain.cpp>
#include <dev_random.cpp>
#include <itpp_ext_math.cpp>
#include <math.h>
#include <tclap/CmdLine.h>
#include <device_functions.h>
#include <cuda.h>
#include "tools.cpp"
#include "cuda_functions.cu"
#include "cuda_utils.cu"
#include "ev_routines.cu"
#include "cfp_routines.cu"
#include <time.h>
// }}}
// TCLAP setup {{{
TCLAP::CmdLine cmd("Command description message", ' ', "0.1");
TCLAP::ValueArg<unsigned int> seed("s","seed", "Random seed [0 for urandom]",false, 243243,"unsigned int",cmd);
TCLAP::ValueArg<string> optionArg("o","option", "Option" ,false,"nichts", "string",cmd);
TCLAP::ValueArg<int> nqubits("q","qubits", "Number of qubits",false, 3,"int",cmd);
TCLAP::ValueArg<int> numt("","t", "Number of time iterartions",false, 1,"int",cmd);
TCLAP::ValueArg<int> position("","position", "The position of something",false, 0,"int",cmd);
TCLAP::ValueArg<int> whichq("","which", "Which qubits in densmat",false, 1,"int",cmd);
TCLAP::ValueArg<int> x("","x", "Size of the x-dimention",false, 0,"int",cmd);
// TCLAP::ValueArg<int> y("","y", "Size of the y-dimention",false, 0,"int",cmd);
//TCLAP::ValueArg<int> position2("","position2", "The position of something",false, 3,"int",cmd);
TCLAP::ValueArg<double> ising("","ising_z", "Ising interaction in the z-direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> deltav("","delta", "Some small delta",false, 1,"double",cmd);
TCLAP::ValueArg<int> trotternum("","trotter", "Number of steps for trotter-suzuki algorithm",false, 1,"int",cmd);
TCLAP::ValueArg<double> bx("","bx", "Magnetic field in x direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> by("","by", "Magnetic field in y direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> bz("","bz", "Magnetic field in z direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> beginx("","startx", "Magnetic field start in x direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> beginz("","startz", "Magnetic field start in z direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> km("","k", "Momentum of the proyector",false,0,"double",cmd);
TCLAP::ValueArg<int> one_state("","one_state", "State l",false, 0,"int",cmd);
TCLAP::ValueArg<int> ifrandom("","ifrandom", "0 if you dont want randstate",false,1,"int",cmd);
TCLAP::ValueArg<int> dev("","dev", "Gpu to be used, 0 for k20, 1 for c20",false, 0,"int",cmd);
  TCLAP::SwitchArg no_general_report("","no_general_report",
      "Print the general report", cmd);
// }}}
double diffclock(clock_t clock1,clock_t clock2) // {{{
{
  double diffticks=clock1-clock2;
  double diffms=(diffticks*1000)/CLOCKS_PER_SEC;
  return diffms;
}  // }}}


// }}}
int main(int argc,char* argv[]) {
  // Setup CUDA devide, random numbers, command line parserc, and other parametrs {{{
  cudaSetDevice(dev.getValue());
//   itpp::RNG_randomize();
double error=0;
  cmd.parse(argc,argv);
  // {{{ Set seed for random
  unsigned int semilla=seed.getValue();
  
//   std::cout << "La semilla es " << semilla << endl;

  if (semilla == 0){
    Random semilla_uran; semilla=semilla_uran.strong();
  } 
  itpp::RNG_reset(semilla);
  // }}}
  // {{{ Report on the screen
  if(!no_general_report.getValue()){
    cout << "#linea de comando: "; 
    for(int i=0;i<argc;i++){ 
      cout <<argv[i]<<" " ;
    } cout << endl ;
    cout << "#semilla = " << semilla << endl; 
    error += system("echo \\#hostname: $(hostname)");
    error += system("echo \\#comenzando en: $(date)");
    error += system("echo \\#uname -a: $(uname -a)");
    error += system("echo \\#working dir: $(pwd)");
  }
  // }}}
  string option=optionArg.getValue();
  
  int l=pow(2,nqubits.getValue());
  int numthreads, numblocks;
  choosenumblocks(l,numthreads,numblocks);
  int div=choosediv(nqubits.getValue());
  // }}}
  // Create workspace in the CPU
  double *R=new double[l], *I=new double[l];
  // Create random state {{{
  
  double *dev_R, *dev_I;
  randomstate(l,R,I);

  if (ifrandom.getValue()!=1) {
    for(int i=0;i<l;i++) {
      R[i]=0;
      I[i]=0;
    }
    R[one_state.getValue()]=1;
  }

  
  cudaSafeCall(cudaMalloc((void**)&dev_R,l*sizeof(double)),"malloc",124);
  cudaSafeCall(cudaMalloc((void**)&dev_I,l*sizeof(double)),"malloc",125);
  
  cudaSafeCall(cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice),"memcpy",127);
  cudaSafeCall(cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice),"memcpy",128);
  // }}}
  if (option=="test_apply_ising") { // {{{
    double mcos=cos(ising.getValue());
    double msin=sin(ising.getValue());
    for(int n=0;n<numt.getValue();n++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,mcos,msin,l);
      }
    }
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaFree(dev_R);
    cudaFree(dev_I);
    for(int i=0;i<l;i++) {
      std::cout<<R[i]<<"  i"<<I[i]<<endl;
    }
  } // }}}
  if (option=="test_apply_magnetic_kick") { // {{{
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double mcos=cos(theta);
    double msin=sin(theta);
    for(int n=0;n<numt.getValue();n++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,mcos,msin,l);
      }
    }
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      std::cout<<R[i]<<"  i"<<I[i]<<endl;
    }
  } // }}}
  if (option=="apply_chain") {  // {{{
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);    
    for(int n=0;n<numt.getValue();n++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	cudaCheckError("kick",i);
      }
    }
    
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      std::cout<<R[i]<<"  i"<<I[i]<<endl;
    }
  } // }}}
  if (option=="measure_time") { // {{{
    cudaEvent_t kstart, kstop;
//     cudaEvent_t cstart, cstop, kstart, kstop;
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);    
    float timek=0;
    cudaEventCreate(&kstart);
    cudaEventCreate(&kstop);
    cudaEventRecord(kstart,0);
    clock_t begin=clock();
    //system("echo \\#Comenzando a hacer varias iteraciones:    $(date)");
    //cout << "Iteraciones son " << numt.getValue() << endl;
    for(int n=0;n<numt.getValue();n++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	cudaCheckError("kick",i);
      }
    }
    
    //system("echo \\#Terminando a hacer varias iteraciones:    $(date)");
    cudaEventRecord(kstop,0);
    cudaEventSynchronize(kstop);
    cudaEventElapsedTime(&timek,kstart,kstop);
    clock_t end=clock();
    double tiempo=double(diffclock(end,begin));
    std::cout<<"CUDA EVENT "<<timek/(numt.getValue()*100)<<endl;
    cout <<"C clock "<<tiempo/(numt.getValue()*100)<< endl;
  } // }}}
  if (option=="check_inverse") { // {{{
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    itpp::cvec initialstate(l);
    itpp::cvec finalstate(l);
    for(int i=0;i<l;i++) {
      initialstate(i)=std::complex<double>(R[i],I[i]);
    }
    //se aplica la U
    for(int t=0;t<numt.getValue();t++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	cudaCheckError("kick",i);
      }
    }
    //Se aplica U^-1
    for(int t=0;t<numt.getValue();t++) {
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	cudaCheckError("kick",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,-1*isin,l);
	cudaCheckError("ising",i);
      }
    }
    
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      finalstate(i)=std::complex<double>(R[i],I[i]);
    }
    cout<<std::norm(itpp::dot(itpp::conj(initialstate),finalstate))<<endl;
  } // }}}
  if (option=="check_inverse_trotter2d") { // {{{
    int xlen=x.getValue();
    int num_trotter=trotternum.getValue();
    double delta=1./num_trotter;
    cout << delta << endl;
    int i_hor,i_ver;
    double icos=cos((delta/2.)*ising.getValue());
    double isin=sin((delta/2.)*ising.getValue());
    double theta=(delta)*sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=delta*bx.getValue()/theta;
    double by2=delta*by.getValue()/theta;
    double bz2=delta*bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    itpp::cvec initialstate(l);
    itpp::cvec finalstate(l);
    for(int i=0;i<l;i++) {
      initialstate(i)=std::complex<double>(R[i],I[i]);
    }
    //se aplica la U
    for(int t=0;t<numt.getValue();t++) {
      for(int it=0;it<num_trotter;it++) {
	for(int i=0;i<nqubits.getValue();i+=2) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	}
	for(int i=0;i<nqubits.getValue();i++) {
	  Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	}
	for(int i=1;i<nqubits.getValue();i+=2) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	}
      }
    }
    //Se aplica U^-1
    for(int t=0;t<numt.getValue();t++) {
      for(int it=0;it<num_trotter;it++) {
	for(int i=1;i<nqubits.getValue();i+=2) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,-1*isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,-1*isin,l);
	}
	for(int i=0;i<nqubits.getValue();i++) {
	  Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	}
	for(int i=0;i<nqubits.getValue();i+=2) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,-1*isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,-1*isin,l);
	}
      }
    }
    
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      finalstate(i)=std::complex<double>(R[i],I[i]);
    }
    cout<<itpp::norm(initialstate-finalstate)<<endl;
  } // }}}
  if (option=="correlation_measure") { // {{{
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double bx2,by2,bz2,kcos,ksin,icos,isin;
    itpp::vec b(3); b(0)=bx.getValue(); b(1)=by.getValue(); b(2)=bz.getValue();
    set_parameters(ising.getValue(),b,icos,isin,kcos,ksin,bx2,by2,bz2);
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
//     double res,norm;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    cudaCheckError("sum_dx",1);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      
      //se aplica U^-1
      for(int t=0;t<n;t++) {
	for(int i=0;i<nqubits.getValue();i++) {
	  Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	  //cudaCheckError("kick",i);
	}
	for(int i=0;i<nqubits.getValue();i++) {
	  Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	  //cudaCheckError("ising",i);
	}
      }
      
      //se aplica la  U 
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
      for(int i=0;i<l;i++) {
	finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
      }
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      //std::cout<<itpp::dot(itpp::conj(zerostate),finalstate);
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="correlation_measure_test") { // {{{
    //this method computes fater correlations at the cost of having two states in global mem
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    double *zeroR=new double[l];
    double *zeroI=new double[l];
    double *dev_zeroR;      
    double *dev_zeroI;
    double *resR=new double[numt.getValue()];
    double *dev_resR;
    double *resI=new double[numt.getValue()];
    double *dev_resI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    cudaMalloc((void**)&dev_zeroR,l*sizeof(double));     
    cudaMalloc((void**)&dev_zeroI,l*sizeof(double));
    cudaMalloc((void**)&dev_resR,numt.getValue()*sizeof(double));
    cudaMalloc((void**)&dev_resI,numt.getValue()*sizeof(double));
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_zeroR,dev_zeroI,nqubits.getValue(),l);
    cudaCheckError("sum_dx",1);
    
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      
      //se aplica U^-1
      for(int t=0;t<n;t++) {
	for(int i=0;i<nqubits.getValue();i++) {
	  Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	  //cudaCheckError("kick",i);
	}
	for(int i=0;i<nqubits.getValue();i++) {
	  Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	  //cudaCheckError("ising",i);
	}
      }
      
      //se aplica la  U 
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      timed_dot<<<numblocks,numthreads>>>(n,dev_zeroR,dev_zeroI,dev_sumdxR,dev_sumdxI,dev_resR,dev_resI,l);
      cudaCheckError("dot",0);
    }
    cudaMemcpy(resR,dev_resR,numt.getValue()*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(resI,dev_resI,numt.getValue()*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<numt.getValue();i++) {
      cout<<sqrt(resR[i]*resR[i]+resI[i]*resI[i])/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="fidelity_measure") { // {{{
    double *AR=new double[l];
    double *AI=new double[l];
    double *dev_AR;      
    double *dev_AI;
    cudaMalloc((void**)&dev_AR,l*sizeof(double));     
    cudaMalloc((void**)&dev_AI,l*sizeof(double));
    double delta=deltav.getValue();
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    double thetadel=delta;
    double bx2del=1.;
    double by2del=0.;
    double bz2del=0.;
    double kcosdel=cos(thetadel);
    double ksindel=sin(thetadel);
    itpp::cvec leftstate(l);
    itpp::cvec rightstate(l);
    for(int i=0;i<l;i++) {
      leftstate(i)=std::complex<double>(R[i],I[i]);
      rightstate(i)=std::complex<double>(R[i],I[i]);
    }
    cout<<std::norm(itpp::dot(itpp::conj(leftstate),rightstate))<<endl;
//     devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_AR,dev_AI);
    for(int n=0;n<numt.getValue();n++) {
      //se aplica la U
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	// cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      //Se aplica M_delta
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2del,by2del,bz2del,kcosdel,ksindel,l);
	//cudaCheckError("kick",i);
      }
      
      
      
      //Se aplica U^-1
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_AR,dev_AI,icos,isin,l);	  
	//cudaCheckError("kick",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_AR,dev_AI,bx2,by2,bz2,kcos,ksin,l);	  
	//cudaCheckError("ising",i);
      }
      
      
      
      cudaMemcpy(AR,dev_AR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(AI,dev_AI,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
      for(int i=0;i<l;i++) {
	leftstate(i)=std::complex<double>(R[i],I[i]);
	rightstate(i)=std::complex<double>(AR[i],AI[i]);
      }
      cout<<std::norm(itpp::dot(itpp::conj(leftstate),rightstate))<<endl;
    }
  } // }}}
  if (option=="fidelity_measure2d") { // {{{
    int xlen=x.getValue();
//     int ylen=y.getValue();
    double *AR=new double[l];
    double *AI=new double[l];
    double *dev_AR;      
    double *dev_AI;
    cudaMalloc((void**)&dev_AR,l*sizeof(double));     
    cudaMalloc((void**)&dev_AI,l*sizeof(double));
    double delta=deltav.getValue();
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    double thetadel=delta;
    double bx2del=1.;
    double by2del=0.;
    double bz2del=0.;
    double kcosdel=cos(thetadel);
    double ksindel=sin(thetadel);
    int i_hor,i_ver;
    itpp::cvec leftstate(l);
    itpp::cvec rightstate(l);
    for(int i=0;i<l;i++) {
      leftstate(i)=std::complex<double>(R[i],I[i]);
      rightstate(i)=std::complex<double>(R[i],I[i]);
    }
    cout<<std::norm(itpp::dot(itpp::conj(leftstate),rightstate))<<endl;
//     devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_AR,dev_AI);
    for(int n=0;n<numt.getValue();n++) {
      //se aplica la U
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	// cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      //Se aplica M_delta
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2del,by2del,bz2del,kcosdel,ksindel,l);
	//cudaCheckError("kick",i);
      }
      
      
      
      //Se aplica U^-1
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_AR,dev_AI,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_AR,dev_AI,icos,isin,l);	  
	//cudaCheckError("kick",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_AR,dev_AI,bx2,by2,bz2,kcos,ksin,l);	  
	//cudaCheckError("ising",i);
      }
      
      
      
      cudaMemcpy(AR,dev_AR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(AI,dev_AI,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
      for(int i=0;i<l;i++) {
	leftstate(i)=std::complex<double>(R[i],I[i]);
	rightstate(i)=std::complex<double>(AR[i],AI[i]);
      }
      cout<<std::norm(itpp::dot(itpp::conj(leftstate),rightstate))<<endl;
    }
  } // }}}
  if (option=="QFT") { // {{{
    for(int n=0;n<numt.getValue();n++) {
      for(int i=0;i<nqubits.getValue();i++) {
	QFT<<<numblocks,numthreads>>>(i,dev_R,dev_I,l,nqubits.getValue());
      }
    }
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      std::cout<<R[i]<<"  i"<<I[i]<<endl;
    }
  } // }}}
  if (option=="correlation_measure_carlos") { // {{{
    itpp::vec magnetic_field(3);
    magnetic_field(0)=bx.getValue();
    magnetic_field(1)=by.getValue();
    magnetic_field(2)=bz.getValue();
    int qubits = nqubits.getValue();
    int xlen=x.getValue();
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    cudaCheckError("sum_dx",1);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      //se aplica U^-1
      evcuda::apply_floquet2d(dev_sumdxR,dev_sumdxI, magnetic_field, ising.getValue() ,qubits, xlen);
      //se aplica U
      evcuda::apply_floquet2d(dev_R, dev_I, magnetic_field, ising.getValue() ,qubits, xlen);
      // se calcula el producto punto
      itppcuda::cuda2itpp(finalstate,dev_sumdxR, dev_sumdxI);
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="correlation_measure2d") { // {{{
    int xlen=x.getValue();
//     int ylen=y.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));
    double bx2,by2,bz2,kcos,ksin,icos,isin;
    itpp::vec b(3); b(0)=bx.getValue(); b(1)=by.getValue(); b(2)=bz.getValue();
    set_parameters(ising.getValue(),b,icos,isin,kcos,ksin,bx2,by2,bz2);
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
//     double res,norm;
    int i_hor,i_ver;
    itpp::vec b_obs(3); b_obs(0)=1.; b_obs(1)=0.; b_obs(2)=0.;
    double cos_obs,sin_obs,bx_obs,by_obs,bz_obs;
    set_parameters(b_obs,cos_obs,sin_obs,bx_obs,by_obs,bz_obs);
    
    //sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
    //OBSERBABLE
	devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_inR,dev_inI);
	for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
	    //cudaCheckError("kick",i);
	  }
    
    //cudaCheckError("sum_dx",1);
    
    
    
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      //sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      //OBSERBABLE
	devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_sumdxR,dev_sumdxI);
	for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
	    //cudaCheckError("kick",i);
	  }
      
      
      cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
      cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
      
      //se aplica U a in
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      //se aplica la  U 
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
     
      for(int i=0;i<l;i++) {
	finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	zerostate(i)=std::complex<double>(inR[i],inI[i]);
      }
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}} 
  if (option=="correlation_obsz") { // {{{
    int xlen=x.getValue();
//     int ylen=y.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double kcos=cos(theta);
    double ksin=sin(theta);
    if(theta==0) {
      theta=1.;
    }
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
//     double res,norm;
    int i_hor,i_ver;
    
    sumsigma_z<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
    //cudaCheckError("sum_dx",1);
    
    
    
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sumsigma_z<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      
      cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
      cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
      
      //se aplica U a in
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      //se aplica la  U 
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
     
      for(int i=0;i<l;i++) {
	finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	zerostate(i)=std::complex<double>(inR[i],inI[i]);
      }
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="correlation_obsy") { // {{{
    int xlen=x.getValue();
//     int ylen=y.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double kcos=cos(theta);
    double ksin=sin(theta);
    if(theta==0) {
      theta=1.;
    }
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
//     double res,norm;
    int i_hor,i_ver;
    
    sigma_xsigma_y<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,1,3,l);
    //cudaCheckError("sum_dx",1);
    
    
    
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sigma_xsigma_y<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,1,3,l);
      
      cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
      cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
      
      //se aplica U a in
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
      //se aplica la  U 
      for(int i=0;i<nqubits.getValue();i++) {
	i_hor=(i+1)%xlen+(i/xlen)*xlen;
	i_ver=(i+xlen)%nqubits.getValue();
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	//cudaCheckError("kick",i);
      }
      
     
      for(int i=0;i<l;i++) {
	finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	zerostate(i)=std::complex<double>(inR[i],inI[i]);
      }
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="color_map2d_no") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
    int i_hor,i_ver;
    double pass;
    int tgo,tback,cont;
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(double bxi=0.0;bxi<1.5;bxi+=0.05) {
      for(double bzi=0.0;bzi<1.5;bzi+=0.05) {
	pass=10.;
	cont=3;
	res=0.;
	double theta=sqrt((bxi*bxi)+(bzi*bzi));
	double kcos=cos(theta);
	double ksin=sin(theta);
	if(theta==0) {
	  theta=1.;
	}
	double bx2=bxi/theta;
	double by2=0;
	double bz2=bzi/theta;
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	tgo=70;
	tback=70;
	while(abs(pass-res)>0.001) {
	  // 	cout<<"pass "<<abs(pass-res)<<endl;
	  pass=res;
	  for(int n=0;n<tgo;n++) {
	    
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	      //cudaCheckError("ising",i);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	      //cudaCheckError("kick",i);
	    }
	  }
	  //se aplica M
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  //cudaCheckError("kick",00);
	  //se aplica U^-1
	  for(int n=0;n<tback;n++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	      // 	    cudaCheckError("kick",i);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      //cout << i << " " << i_hor << " " << i_ver << endl;
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      //cudaCheckError("ising",i);
	    }
	  }
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  tgo=cont;
	  tback=70+cont;
	  cont++;
	}
	cout<< bxi << " " << bzi <<" "<<res<<" "<<cont-3<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res;
    int i_hor,i_ver;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(double bxi=0.0;bxi<=1.5;bxi+=0.01) {
      for(double bzi=0.0;bzi<=0;bzi+=0.05) {
	double theta=sqrt((bxi*bxi)+(bzi*bzi));
	double kcos=cos(theta);
	double ksin=sin(theta);
	if(theta==0) {
	  theta=1.;
	}
	double bx2=bxi/theta;
	double by2=0;
	double bz2=bzi/theta;
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	
	for(int n=0;n<70;n++) {
	  
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<30;in++) {
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  for(int back=0;back<71+in;back++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	      // 	    cudaCheckError("kick",i);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      //cout << i << " " << i_hor << " " << i_ver << endl;
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      //cudaCheckError("ising",i);
	    }
	  }
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_fast") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res,bx2,by2,bz2,kcos,ksin,icos,isin,ising;
    int i_hor,i_ver;    
    
    itpp::vec b_obs(3); b_obs(0)=1.; b_obs(1)=0.; b_obs(2)=0.;
    double cos_obs,sin_obs,bx_obs,by_obs,bz_obs;
    set_parameters(b_obs,cos_obs,sin_obs,bx_obs,by_obs,bz_obs);
    double bxi,bzi;
    for(int bxii=0;bxii<=360;bxii+=1) {
      for(int bzii=0;bzii<=180;bzii+=1) {
	bxi=bxii*itpp::pi/720.;
	bzi=bzii*itpp::pi/720.;
	itpp::vec b(3); b(0)=bxi; b(1)=0.; b(2)=0.;
	ising=bzi;
	set_parameters(ising,b,icos,isin,kcos,ksin,bx2,by2,bz2);
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	
	//OBSERBABLE
	sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
// 	devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_inR,dev_inI);
// 	for(int i=0;i<nqubits.getValue();i++) {
// 	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
// 	    //cudaCheckError("kick",i);
// 	  }
// 	  
	
	for(int n=0;n<70;n++) {
	  
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	    cudaCheckError("ising",i);
	  }
	  
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<30;in++) {
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  //OBSERVABLE
// 	  devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_sumdxR,dev_sumdxI);
// 	  for(int i=0;i<nqubits.getValue();i++) {
// 	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
// 	    //cudaCheckError("kick",i);
// 	  }
	 
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  //res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)));
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_block") { // {{{
    int xlen=x.getValue();
    
    itpp::cmat eigenvectors1=evcuda::invariant_vectors(nqubits.getValue(),x.getValue(),1,1,0);
	itpp::cmat eigenvectors2=evcuda::invariant_vectors(nqubits.getValue(),x.getValue(),1,2,0);

	int rcont1=eigenvectors1.rows();
	int rcont2=eigenvectors2.rows();
	
	
	itpp::cvec small_state=itppextmath::RandomState(rcont1);
	itpp::cvec state = itpp::transpose(eigenvectors1)*small_state;
	small_state=itppextmath::RandomState(rcont2);
	state=state+itpp::transpose(eigenvectors2)*small_state;
	state=state/itpp::norm(state);
	
	evcuda::itpp2cuda(state,dev_R,dev_I);
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res,bx2,by2,bz2,kcos,ksin,icos,isin,ising;
    int i_hor,i_ver;    
    
    itpp::vec b_obs(3); b_obs(0)=1./sqrt(3); b_obs(1)=1./sqrt(3); b_obs(2)=1./sqrt(3);
    double cos_obs,sin_obs,bx_obs,by_obs,bz_obs;
    set_parameters(b_obs,cos_obs,sin_obs,bx_obs,by_obs,bz_obs);
    
    for(double bxi=0.0;bxi<=itpp::pi/2;bxi+=itpp::pi/80) {
      for(double bzi=0.0;bzi<=itpp::pi/2;bzi+=itpp::pi/80) {
	itpp::vec b(3); b(0)=bxi; b(1)=0.; b(2)=0.;
	ising=bzi;
	set_parameters(ising,b,icos,isin,kcos,ksin,bx2,by2,bz2);
	evcuda::itpp2cuda(state,dev_R,dev_I);
	
	//OBSERBABLE
	sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
	//devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_inR,dev_inI);
// 	for(int i=0;i<nqubits.getValue();i++) {
// 	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
// 	    //cudaCheckError("kick",i);
// 	  }
	  
	
	for(int n=0;n<70;n++) {
	  
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //CHAIN
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	    cudaCheckError("ising",i);
	  }
	  
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //CHAIN
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<1;in++) {
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  //OBSERVABLE
// 	  devcpy<<<numblocks,numthreads>>>(l,dev_R,dev_I,dev_sumdxR,dev_sumdxI);
// 	  for(int i=0;i<nqubits.getValue();i++) {
// 	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,bx_obs,by_obs,bz_obs,cos_obs,sin_obs,l);
// 	    //cudaCheckError("kick",i);
// 	  }
	 
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //CHAIN
	    //Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //CHAIN
	    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_fast_obsz") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res,bx2,by2,bz2,kcos,ksin,ising,icos,isin;
    int i_hor,i_ver;    
    
    for(double bxi=0.;bxi<=3.2;bxi+=0.05) {
      for(double bzi=0.;bzi<=3.2;bzi+=0.05) {
	itpp::vec b(3); b(0)=bxi; b(1)=0.; b(2)=0.;
	ising=bzi;
	set_parameters(ising,b,icos,isin,kcos,ksin,bx2,by2,bz2);
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	sumsigma_z<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
	
	for(int n=0;n<70;n++) {
	  
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<30;in++) {
	  sumsigma_z<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_fast_obsy") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res,bx2,by2,bz2,kcos,ksin,ising,icos,isin;
    int i_hor,i_ver;    
    
    for(double bxi=0.;bxi<=3.2;bxi+=0.05) {
      for(double bzi=0.;bzi<=3.2;bzi+=0.05) {
	itpp::vec b(3); b(0)=bxi; b(1)=0.; b(2)=0.;
	ising=bzi;
	set_parameters(ising,b,icos,isin,kcos,ksin,bx2,by2,bz2);
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	sumsigma_y<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
	
	for(int n=0;n<70;n++) {
	  
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<30;in++) {
	  sumsigma_y<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_fast_in70") { // {{{
    int xlen=x.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(1);
     double res,bx2,by2,bz2,kcos,ksin,ising,icos,isin;  
    
    for(double bxi=0.0;bxi<=3.2;bxi+=0.05) {
      for(double bzi=0.0;bzi<=3.2;bzi+=0.05) {
	itpp::vec b(3); b(0)=bxi; b(1)=0.; b(2)=0.;
	ising=bzi;
	set_parameters(ising,b,icos,isin,kcos,ksin,bx2,by2,bz2);
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
	
	for(int n=0;n<10;n++) {
	  
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	//cudaCheckError("ising",i);
      }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	}
	
	for(int in=0;in<1;in++) {
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_inR,dev_inI,icos,isin,l);
	//cudaCheckError("ising",i);
      }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  //se aplica la  U 
	  for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)/(double)nqubits.getValue()));
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev__trotter1g_fast") { // {{{
    int xlen=x.getValue();
    int num_trotter=trotternum.getValue();
    double delta=1./num_trotter;
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos(delta*ising.getValue());
    double isin=sin(delta*ising.getValue());
    double *inR=new double[l];
    double *inI=new double[l];
    double *dev_inR;      
    double *dev_inI;
    cudaMalloc((void**)&dev_inR,l*sizeof(double));     
    cudaMalloc((void**)&dev_inI,l*sizeof(double));    
    
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res;
    int i_hor,i_ver;    
    
    for(double bxi=0.0;bxi<=1.5;bxi+=0.05) {
      for(double bzi=0.0;bzi<=1.5;bzi+=0.05) {
	double theta=delta*sqrt((bxi*bxi)+(bzi*bzi));
	double kcos=cos(theta);
	double ksin=sin(theta);
	if(theta==0) {
	  theta=1.;
	}
	double bx2=delta*bxi/theta;
	double by2=0;
	double bz2=delta*bzi/theta;
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits.getValue(),l);
	
	for(int n=0;n<70;n++) {
	  
	  
	  //se aplica U a in
	  for(int trot=0;trot<num_trotter;trot++) {
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  }
	  
	  //se aplica la  U 
	  for(int trot=0;trot<num_trotter;trot++) {
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  }
	}
	
	for(int in=0;in<30;in++) {
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inR,dev_inR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(inI,dev_inI,l*sizeof(double),cudaMemcpyDeviceToHost);   
	  
	  //se aplica U a in
	  for(int trot=0;trot<num_trotter;trot++) {
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_inR,dev_inI,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_inR,dev_inI,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_inR,dev_inI,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  }
	  
	  //se aplica la  U 
	  for(int trot=0;trot<num_trotter;trot++) {
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    //cudaCheckError("ising",i);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    //cudaCheckError("kick",i);
	  }
	  }
	  
	  
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	    zerostate(i)=std::complex<double>(inR[i],inI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_trotter2g") { // {{{
    int xlen=x.getValue();
    int num_trotter=trotternum.getValue();
    double delta=1./num_trotter;
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos((delta/2)*ising.getValue());
    double isin=sin((delta/2)*ising.getValue());
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res;
    int i_hor,i_ver;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(double bxi=beginx.getValue();bxi<=1.5;bxi+=0.05) {
      for(double bzi=0.0;bzi<=1.5;bzi+=0.05) {
	double theta=delta*sqrt((bxi*bxi)+(bzi*bzi));
	double kcos=cos(theta);
	double ksin=sin(theta);
	if(theta==0) {
	  theta=1.;
	}
	double bx2=delta*bxi/theta;
	double by2=0;
	double bz2=delta*bzi/theta;
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	
	for(int n=0;n<70;n++) {
	  
	  for(int it=0;it<num_trotter;it++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	  }
	}
	
	for(int in=0;in<30;in++) {
	  for(int it=0;it<num_trotter;it++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	  }
	  
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  for(int back=0;back<71+in;back++) {
	    for(int it=0;it<num_trotter;it++) {
	      for(int i=0;i<nqubits.getValue();i++) {
		i_hor=(i+1)%xlen+(i/xlen)*xlen;
		i_ver=(i+xlen)%nqubits.getValue();
		Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
		Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      }
	      for(int i=0;i<nqubits.getValue();i++) {
		Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	      }
	      for(int i=0;i<nqubits.getValue();i++) {
		i_hor=(i+1)%xlen+(i/xlen)*xlen;
		i_ver=(i+xlen)%nqubits.getValue();
		Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
		Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      }
	    }
	  }
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="color_map2d_stdev_trotter1g") { // {{{
    int xlen=x.getValue();
    int num_trotter=trotternum.getValue();
    double delta=1./num_trotter;
    cout<<"delta " << delta<<endl;
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos((delta)*ising.getValue());
    double isin=sin((delta)*ising.getValue());
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    itpp::vec correlations(30);
    double res;
    int i_hor,i_ver;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(double bxi=beginx.getValue();bxi<1.5;bxi+=0.05) {
      for(double bzi=0.;bzi<1.5;bzi+=0.05) {
	double theta=delta*sqrt((bxi*bxi)+(bzi*bzi));
	double kcos=cos(theta);
	double ksin=sin(theta);
	if(theta==0) {
	  theta=1.;
	}
	double bx2=delta*bxi/theta;
	double by2=0;
	double bz2=delta*bzi/theta;
	cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
	cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
	
	for(int n=0;n<70;n++) {
	  
	  for(int it=0;it<num_trotter;it++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    }
	  }
	}
	
	for(int in=0;in<30;in++) {
	  for(int it=0;it<num_trotter;it++) {
	    for(int i=0;i<nqubits.getValue();i++) {
	      i_hor=(i+1)%xlen+(i/xlen)*xlen;
	      i_ver=(i+xlen)%nqubits.getValue();
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	      Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	    }
	    for(int i=0;i<nqubits.getValue();i++) {
	      Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	    }
	  }
	  
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
	  
	  for(int back=0;back<71+in;back++) {
	    for(int it=0;it<num_trotter;it++) {
	      for(int i=0;i<nqubits.getValue();i++) {
		Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	      }
	      for(int i=0;i<nqubits.getValue();i++) {
		i_hor=(i+1)%xlen+(i/xlen)*xlen;
		i_ver=(i+xlen)%nqubits.getValue();
		Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
		Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	      }         
	    }
	  }
	  cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
	  cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
	  for(int i=0;i<l;i++) {
	    finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
	  }
	  res=sqrt(std::norm(itpp::dot(itpp::conj(zerostate),finalstate)))/nqubits.getValue();
	  correlations(in)=res;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;
      }
    }
  } // }}}
  if (option=="test_2d_grid") { // {{{
    int xlen=x.getValue();
//     int ylen=y.getValue();
    
    
    //cout<<square<<endl;
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    
    for(int n=0;n<numt.getValue();n++) { 
      for(int i=0;i<nqubits.getValue();i++) {
	int i_hor=(i+1)%xlen+(i/xlen)*xlen;
	int i_ver=(i+xlen)%nqubits.getValue();
	cout << i << " " << i_hor << " " << i_ver << endl;
	Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	//cudaCheckError("ising",i);
      }
    }
    
    cudaMemcpy(R,dev_R,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(I,dev_I,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaFree(dev_R);
    cudaFree(dev_I);
    for(int i=0;i<l;i++) {
      std::cout<<R[i]<<"  i"<<I[i]<<endl;
    }
  }  // }}}
  if (option=="exp_lattice") { // {{{
    //nqubits debe corresponder a un cuadro
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(pow(bx.getValue(),2)+pow(by.getValue(),2)+pow(bz.getValue(),2));
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    double *dotR=new double[nqubits.getValue()];
    double *dotI=new double[nqubits.getValue()];
    double *dev_dotR;      
    double *dev_dotI;
    cudaMalloc((void**)&dev_dotR,nqubits.getValue()*sizeof(double));     
    cudaMalloc((void**)&dev_dotI,nqubits.getValue()*sizeof(double));
    //cout<<div<<endl;
    
    for(int t=0;t<numt.getValue();t++) {
      for(int i=0;i<nqubits.getValue();i++) {
	dotR[i]=0;
	dotI[i]=0;
      }
      cudaSafeCall(cudaMemcpy(dev_dotR,dotR,nqubits.getValue()*sizeof(double),cudaMemcpyHostToDevice),"cudaMalloc",1);
      cudaSafeCall(cudaMemcpy(dev_dotI,dotI,nqubits.getValue()*sizeof(double),cudaMemcpyHostToDevice),"cudaMalloc",2);
      for(int i=0;i<nqubits.getValue();i++) {
	// 	dot_2<<<numblocks,numthreads>>>(1,1,i,dev_R,dev_I,dev_dotR,dev_dotI,l);
	//cudaDeviceSynchronize();
	cudaCheckError("dot",i);
      }
      cudaSafeCall(cudaMemcpy(dotR,dev_dotR,nqubits.getValue()*sizeof(double),cudaMemcpyDeviceToHost),"cudaMalloc",3);
      cudaSafeCall(cudaMemcpy(dotI,dev_dotI,nqubits.getValue()*sizeof(double),cudaMemcpyDeviceToHost),"cudaMalloc",4);
      for(int i=0;i<nqubits.getValue();i++) {
	cout<<dotR[i]<<" ";
      }
      cout<<endl;
      for(int is=0;is<nqubits.getValue();is++) {
	//Ui_kernel<<<numblocks,numthreads>>>(is,(is+1)%5,dev_R,dev_I,icos,isin,l);
	Ui_kernel<<<numblocks,numthreads>>>(is,(is+5)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	cudaCheckError("ising",is);
      }
      for(int ki=0;ki<nqubits.getValue();ki++) {
	Uk_kernel<<<numblocks,numthreads>>>(ki,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	cudaCheckError("kick",ki);
      }
    }
    cudaFree(dev_dotR);
    cudaFree(dev_dotI); 
  } // }}}
  if (option=="test_densmat") { // {{{
    int ndens=pow(2,numbits(whichq.getValue()));
    double *densR=new double[ndens*ndens];
    double *densI=new double[ndens*ndens];
    double *dev_densR;      
    double *dev_densI;
    cudaMalloc((void**)&dev_densR,ndens*ndens*sizeof(double));     
    cudaMalloc((void**)&dev_densI,ndens*ndens*sizeof(double));
    for(int i=0;i<ndens*ndens;i++) {
      densR[i]=0;
      densI[i]=0;
    }
    cudaSafeCall(cudaMemcpy(dev_densR,densR,ndens*ndens*sizeof(double),cudaMemcpyHostToDevice),"cudaMemcpy",1);
    cudaSafeCall(cudaMemcpy(dev_densI,densI,ndens*ndens*sizeof(double),cudaMemcpyHostToDevice),"cudaMemcpy",2);
    int div=choosediv(nqubits.getValue());
    //     int blockdivdens,threaddivdens;
    //     choosedivdens(l,blockdivdens,threaddivdens);
    cout<<numblocks<<"  "<<numthreads/ndens<<endl;
    for(int i=0;i<ndens;i++) {
      for(int j=0;j<ndens;j++) {
	density_matrix<<<numblocks,numthreads/ndens>>>(whichq.getValue(),ndens,i,j,dev_R,dev_I,dev_densR,dev_densI,l/ndens);
	cudaCheckError("dot",i+j);
      }
    }
    cudaSafeCall(cudaMemcpy(densR,dev_densR,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost),"cudaMemcpy",3);
    cudaSafeCall(cudaMemcpy(densI,dev_densI,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost),"cudaMemcpy",4);
    for(int i=0;i<ndens;i++) {
      for(int j=0;j<ndens;j++) {
	cout<<densR[(ndens*i)+j]<<" i"<<densI[(ndens*i)+j]<<" ";
     }
      cout<<endl;
    }
    cudaFree(dev_densR);
    cudaFree(dev_densI);
  } // }}}
  if (option=="exp_cadena_densmat") { // {{{
    double icos=cos(ising.getValue());
    double isin=sin(ising.getValue());
    double theta=sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=bx.getValue()/theta;
    double by2=by.getValue()/theta;
    double bz2=bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    int ndens=pow(2,numbits(whichq.getValue()));
    double *densR=new double[ndens*ndens];
    double *densI=new double[ndens*ndens];
    double *dev_densR;      
    double *dev_densI;
    cudaMalloc((void**)&dev_densR,ndens*ndens*sizeof(double));     
    cudaMalloc((void**)&dev_densI,ndens*ndens*sizeof(double));
    itpp::cmat dens(2,2);
    // which temp para sacar matdens todos
    //for(int n=0;n<nqubits.getValue();n++) {
    for(int n=0;n<numt.getValue();n++) {
      for(int qus=0;qus<nqubits.getValue();qus++) {
	int whichtemp=pow(2,qus);
	for(int i=0;i<ndens*ndens;i++) {
	  densR[i]=0;
	  densI[i]=0;
	}
	cudaSafeCall(cudaMemcpy(dev_densR,densR,ndens*ndens*sizeof(double),cudaMemcpyHostToDevice),"cudaMemcpy",1);
	cudaSafeCall(cudaMemcpy(dev_densI,densI,ndens*ndens*sizeof(double),cudaMemcpyHostToDevice),"cudaMemcpy",2);
	for(int i=0;i<ndens;i++) {
	  for(int j=0;j<ndens;j++) {
	    //whichtemp aqui
	    density_matrix<<<numblocks,numthreads/ndens>>>(whichtemp,ndens,i,j,dev_R,dev_I,dev_densR,dev_densI,l/ndens);
	    cudaCheckError("dot",i+j);
	  }
	}
	cudaSafeCall(cudaMemcpy(densR,dev_densR,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost),"cudaMemcpy",3);
	cudaSafeCall(cudaMemcpy(densI,dev_densI,ndens*ndens*sizeof(double),cudaMemcpyDeviceToHost),"cudaMemcpy",4);
	for(int i=0;i<ndens;i++) {
	  for(int j=0;j<ndens;j++) {
	    dens(i,j)=std::complex<double>(densR[(ndens*i)+j],densI[(ndens*i)+j]);
	  }
	}
	cout<<real(itpp::trace(dens*itppextmath::sigma(3)))<<endl;
	//       cout<<"-----------------otro qubit-----------------------"<<endl;
      }
      for(int i=0;i<nqubits.getValue();i++) {
	Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%nqubits.getValue(),dev_R,dev_I,icos,isin,l);
	cudaCheckError("ising",i);
      }
      
      for(int i=0;i<nqubits.getValue();i++) {
	Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	cudaCheckError("ising",i);
      }
      //cout<<endl;
    }
    cudaFree(dev_densR);
    cudaFree(dev_densI);
  } // }}}
  if(option=="correlation_measure2d_trotter") { // {{{
    int num_trotter=trotternum.getValue();
    double delta=1./num_trotter;
    int xlen=x.getValue();
//     int ylen=y.getValue();
    //     cout<<square<<endl;
    double *sumdxR=new double[l];
    double *sumdxI=new double[l];
    double *dev_sumdxR;      
    double *dev_sumdxI;
    cudaMalloc((void**)&dev_sumdxR,l*sizeof(double));     
    cudaMalloc((void**)&dev_sumdxI,l*sizeof(double));
    double icos=cos((delta/2)*ising.getValue());
    double isin=sin((delta/2)*ising.getValue());
    double theta=(delta)*sqrt(bx.getValue()*bx.getValue()+by.getValue()*by.getValue()+bz.getValue()*bz.getValue());
    double bx2=delta*bx.getValue()/theta;
    double by2=delta*by.getValue()/theta;
    double bz2=delta*bz.getValue()/theta;
    double kcos=cos(theta);
    double ksin=sin(theta);
    itpp::cvec finalstate(l);
    itpp::cvec zerostate(l);
    double res;
//     double res,norm;
    int i_hor,i_ver;
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
    cudaCheckError("sum_dx",1);
    
    cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
    for(int i=0;i<l;i++) {
      zerostate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
    }
    
    for(int n=0;n<numt.getValue();n++) {
      //se aplica M
      sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits.getValue(),l);
      
      //se aplica U^-1
      for(int t=0;t<n;t++) {
	for(int it=0;it<num_trotter;it++) {
	  for(int i=1;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    Uk_kernel<<<numblocks,numthreads>>>(i,dev_sumdxR,dev_sumdxI,-1*bx2,-1*by2,-1*bz2,kcos,ksin,l);
	  }
	  for(int i=0;i<nqubits.getValue();i++) {
	    i_hor=(i+1)%xlen+(i/xlen)*xlen;
	    i_ver=(i+xlen)%nqubits.getValue();
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_sumdxR,dev_sumdxI,icos,-1*isin,l);
	  }
	}
      }
      
      //se aplica la  U 
      for(int it=0;it<num_trotter;it++) {
	for(int i=0;i<nqubits.getValue();i++) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	}
	for(int i=0;i<nqubits.getValue();i++) {
	  Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx2,by2,bz2,kcos,ksin,l);
	}
	for(int i=1;i<nqubits.getValue();i++) {
	  i_hor=(i+1)%xlen+(i/xlen)*xlen;
	  i_ver=(i+xlen)%nqubits.getValue();
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,icos,isin,l);
	  Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,icos,isin,l);
	}
      }
      
      cudaMemcpy(sumdxR,dev_sumdxR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(sumdxI,dev_sumdxI,l*sizeof(double),cudaMemcpyDeviceToHost);
      for(int i=0;i<l;i++) {
	finalstate(i)=std::complex<double>(sumdxR[i],sumdxI[i]);
      }
      res=std::norm(itpp::dot(itpp::conj(zerostate),finalstate));
      cout<<sqrt(res)/nqubits.getValue()<<endl;
    }
  } // }}}
  if (option=="test_proyector_big") { // {{{
    itpp::cvec proyectado(l);
    double *rotR=new double[l];
    double *rotI=new double[l];
    double *dev_rotR;      
    double *dev_rotI;
    cudaMalloc((void**)&dev_rotR,l*sizeof(double));     
    cudaMalloc((void**)&dev_rotI,l*sizeof(double));
    
    for(int i=1;i<x.getValue();i++) {
      vertical_rotation<<<numblocks,numthreads>>>(dev_R,dev_I,dev_rotR,dev_rotI,x.getValue(),nqubits.getValue(),l,i);
      cudaMemcpy(rotR,dev_rotR,l*sizeof(double),cudaMemcpyDeviceToHost);
      cudaMemcpy(rotI,dev_rotI,l*sizeof(double),cudaMemcpyDeviceToHost);
      for(int j=0;j<l;j++) {
	R[j]=R[j]+cos(2*itpp::pi*km.getValue()*i/x.getValue())*rotR[j]-sin(2*itpp::pi*km.getValue()*i/x.getValue())*rotI[j];
	I[j]=I[j]+sin(2*itpp::pi*km.getValue()*i/x.getValue())*rotR[j]+cos(2*itpp::pi*km.getValue()*i/x.getValue())*rotI[j];
      }
    }
    
    cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
    cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
    
    vertical_rotation<<<numblocks,numthreads>>>(dev_R,dev_I,dev_rotR,dev_rotI,x.getValue(),nqubits.getValue(),l);
    cudaMemcpy(rotR,dev_rotR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(rotI,dev_rotI,l*sizeof(double),cudaMemcpyDeviceToHost);
    
    std::complex<double> fase=std::exp(std::complex<double>(0,-2*itpp::pi*km.getValue()/x.getValue()));    
    
    for(int i=0;i<l;i++) {
      //cout<<std::complex<double>(rotR[i],rotI[i])/std::complex<double>(R[i],I[i])<<endl;
      proyectado(i)=fase*(std::complex<double>(R[i],I[i]))-std::complex<double>(rotR[i],rotI[i]);
      //cout<<"---->"<<proyectado(i)<<endl;
    }
    cout<<"-----------------"<<endl;
    cout<<itpp::norm(proyectado)<<endl;
    //cout<<fase<<endl;
    
    
  } // }}}
  if (option=="test_proyector") { // {{{
    itpp::cvec proyectado(l);
    double *rotR=new double[l];
    double *rotI=new double[l];
    double *dev_rotR;      
    double *dev_rotI;
    cudaMalloc((void**)&dev_rotR,l*sizeof(double));     
    cudaMalloc((void**)&dev_rotI,l*sizeof(double));
    itpp::cvec vector(l);
    for(int i=0;i<l;i++) {
      vector(i)=std::complex<double>(R[i],I[i]);
    }
    vertical_proyector<<<numblocks,numthreads>>>(dev_R,dev_I,dev_rotR,dev_rotI,x.getValue(),nqubits.getValue(),l,km.getValue());    
    cudaMemcpy(rotR,dev_rotR,l*sizeof(double),cudaMemcpyDeviceToHost);
    cudaMemcpy(rotI,dev_rotI,l*sizeof(double),cudaMemcpyDeviceToHost);  
    for(int i=0;i<l;i++) {
      proyectado(i)=std::complex<double>(rotR[i],rotI[i]);
    }
    
    
    evcuda::proyector_vertical_itpp(vector,dev_R,dev_I,dev_rotR,dev_rotI,x.getValue(),km.getValue());
    
    cout<< proyectado<<endl;
    cout<<vector<<endl;
    cout<<itpp::norm(proyectado-vector)<<endl;
    itpp::cvec rotado=proyectado;
    itpp::cvec rotado2=vector;
    int nx = x.getValue();
    evcuda::apply_vertical_rotation_itpp(rotado,dev_R,dev_I,dev_rotR,dev_rotI,nx); 
    evcuda::apply_vertical_rotation_itpp(rotado2,dev_R,dev_I,dev_rotR,dev_rotI,nx); 
    
    double error = abs(itppextmath::proportionality_test(rotado,proyectado));
    double error2 = abs(itppextmath::proportionality_test(proyectado,vector));
    
    cout << "Error en la proporcionalidad es del cuda "  << error << endl;
    cout << "Error en la proporcionalidad es del normal-- "  << error2 << endl;
    //cout<<proyectado<<endl;
    //cout<<vector<<endl;
  } // }}}
  if (option=="assemble_matrix") { // {{{
    double *rotR=new double[l];
    double *rotI=new double[l];
    double *dev_rotR;      
    double *dev_rotI;
    cudaMalloc((void**)&dev_rotR,l*sizeof(double));     
    cudaMalloc((void**)&dev_rotI,l*sizeof(double)); 
    int *A=new int[l];
    for(int i=0;i<l;i++) {
      A[i]=2;
    }
    find_states_horizontal(A,nqubits.getValue(),x.getValue(),km.getValue(),l);
    int cont=0;
    for(int i=0;i<l;i++) {
      cont+=A[i];
    }
    itpp::cmat eigenvectors(cont,cont);
    for(int vec=0;vec<cont;vec++) {
      int flag=0;
      for(int i=0;i<l;i++) {
	if(A[i]=1 && flag==0) {
	  R[i]=1.;
	  flag=1;
	  A[i]=0;
	}
	else {
	  R[i]=0.;
	}
	I[i]=0;
      }
      cudaMemcpy(dev_R,R,l*sizeof(double),cudaMemcpyHostToDevice);
      cudaMemcpy(dev_I,I,l*sizeof(double),cudaMemcpyHostToDevice);
      for(int i=1;i<x.getValue();i++) {
	horizontal_rotation<<<numblocks,numthreads>>>(dev_R,dev_I,dev_rotR,dev_rotI,x.getValue(),nqubits.getValue(),l,i);
	cudaMemcpy(rotR,dev_rotR,l*sizeof(double),cudaMemcpyDeviceToHost);
	cudaMemcpy(rotI,dev_rotI,l*sizeof(double),cudaMemcpyDeviceToHost);
	for(int j=0;j<l;j++) {
	  R[j]=R[j]+cos(2*itpp::pi*km.getValue()*i/x.getValue())*rotR[j]-sin(2*itpp::pi*km.getValue()*i/x.getValue())*rotI[j];
	  I[j]=I[j]+sin(2*itpp::pi*km.getValue()*i/x.getValue())*rotR[j]+cos(2*itpp::pi*km.getValue()*i/x.getValue())*rotI[j];
	}
      }
      
      
      for(int i=0;i<l;i++) {
	eigenvectors(vec,i)=std::complex<double>(R[i],I[i]);
      }
    }
  } // }}}
  cudaFree(dev_R);
  cudaFree(dev_I);
  // {{{ Final report
  if(!no_general_report.getValue()){
    error += system("echo \\#terminando:    $(date)");
  }
  // }}}
  return 0;
}



