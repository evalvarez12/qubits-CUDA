#include <iostream>
#include <fstream>
#include <cstdlib>
#include <itpp/itbase.h>
#include <cpp/dev_random.cpp>
#include <cpp/itpp_ext_math.cpp>
#include <cpp/spinchain.cpp>
#include <math.h>
#include <tclap/CmdLine.h>
#include <device_functions.h>
#include <cuda.h>
#include "tools.cpp"
#include "cuda_utils.cu"
#include "model.cu"
#include "ev_routines.cu"
#include "ev_math.cu"
#include "cuda_functions.cu"
#include "ex_model.cu"
#include <time.h>


TCLAP::CmdLine cmd("Command description message", ' ', "0.1");
TCLAP::ValueArg<unsigned int> CseedArg("","Cseed", "Random seed [0 for urandom]",false, 0,"unsigned int",cmd);
TCLAP::ValueArg<unsigned int> EseedArg("","Eseed", "Random seed [0 for urandom]",false, 0,"unsigned int",cmd);
TCLAP::ValueArg<unsigned int> PARAMseedArg("","PARAMseed", "Random seed [0 for urandom]",false, 0,"unsigned int",cmd);
TCLAP::ValueArg<string> optionArg("o","option", "Option" ,false,"nichts", "string",cmd);
TCLAP::ValueArg<int> nqubitsArg("q","qubits", "Number of qubits",false, 3,"int",cmd);
TCLAP::ValueArg<int> numtArg("","t", "Number of time iterartions",false, 1,"int",cmd);
TCLAP::ValueArg<double> JArg("","Jc", "Ising interaction in the z-direction",false, 0.,"double",cmd);
TCLAP::ValueArg<double> JpArg("","Jp", "Ising interaction between A and B",false, 0.,"double",cmd);
TCLAP::ValueArg<double> DJs("","DJs", "Delta in the Js interacions on chain",false, 0.,"double",cmd);
TCLAP::ValueArg<double> Js("","Js", "Center of the Js interactions on chain",false, 0,"double",cmd);
TCLAP::ValueArg<double> bx("","bx", "Magnetic field in x direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> by("","by", "Magnetic field in y direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> bz("","bz", "Magnetic field in z direction",false, 0,"double",cmd);
TCLAP::ValueArg<double> Dbs("","Dbs", "Delta in the magnetic field on spins",false, 0,"double",cmd);
TCLAP::ValueArg<int> one_state("","one_state", "State l",false, 0,"int",cmd);
TCLAP::ValueArg<int> ifrandom("","ifrandom", "0 if you dont want randstate",false,1,"int",cmd);
TCLAP::ValueArg<int> dev("","dev", "Gpu to be used, 0 for k20, 1 for c20",false, 0,"int",cmd);
TCLAP::SwitchArg no_general_report("","no_general_report","Print the general report", cmd);
TCLAP::ValueArg<string> modelArg("","model", "Option" ,false,"nichts", "string",cmd);
TCLAP::ValueArg<int> tAvg("","t_ave", "Number of time averaged over",false, 1,"int",cmd);
TCLAP::ValueArg<int> xlenArg("","x", "Some number x",false, 0,"int",cmd);
TCLAP::ValueArg<int> symr("","symR", "If symmetries sectors of reflections are used",false, 0,"int",cmd);

int main(int argc,char* argv[]) {
  // Set initial stuff
  cout.precision(17);
  cudaSetDevice(dev.getValue());
  itpp::RNG_randomize();
  cmd.parse(argc,argv);
  string option=optionArg.getValue();
  string model=modelArg.getValue();
  double J=JArg.getValue();
  double Jp=JpArg.getValue();
  int nqubits = nqubitsArg.getValue();
  int numt=numtArg.getValue();
  int xlen=xlenArg.getValue();
  
  
  int l=pow(2,nqubits);    
  int nqubits_env,xl;
  
  itpp::ivec conxA,conxB;
  
  //Se elige el modelo a usar
  void (*evolution)(double *, double *, itpp::vec, double, double, itpp::mat, int, int, itpp::ivec, itpp::ivec);
  if(model=="model1") {
    evolution=model::model1;
    nqubits_env=nqubits-1;
  }
  if(model=="model11") {
    evolution=model::model11;
    nqubits_env=nqubits-1;
  }  
  if(model=="model2") {
    evolution=model::model2;
    nqubits_env=nqubits-1;
  }
  if(model=="model3") {
    evolution=model::model3;
    nqubits_env=nqubits-1;
  }
  if(model=="model3_open") {
    evolution=model::model3_open;
    nqubits_env=nqubits-1;
  }
  if(model=="model3_open_op1") {
    evolution=extra_model::model3_open_op1;
    nqubits_env=nqubits-1;
  }
  if(model=="model3_open_op2") {
    evolution=extra_model::model3_open_op2;
    nqubits_env=nqubits-1;
  }
  if(model=="model3_open_op3") {
    evolution=extra_model::model3_open_op3;
    nqubits_env=nqubits-1;
  }  
  if(model=="model3_open_op4") {
    evolution=extra_model::model3_open_op4;
    nqubits_env=nqubits-1;
  }  
  if(model=="model3_open_op5") {
    evolution=extra_model::model3_open_op5;
    nqubits_env=nqubits-1;
  }  
  if(model=="model3_open_op6") {
    evolution=extra_model::model3_open_op6;
    nqubits_env=nqubits-1;
  }    
  if(model=="model4") {
    evolution=model::model4;
    nqubits_env=nqubits-1;
  }
  if(model=="model4_open") {
    evolution=model::model4_open;
    nqubits_env=nqubits-1;
  }
  if(model=="model5") {
    evolution=model::model5;
    nqubits_env=nqubits-1;
  }
  if(model=="model5_open") {
    evolution=model::model5_open;
    nqubits_env=nqubits-1;
  }
  if(model=="model7") {
    evolution=model::model7;
    nqubits_env=nqubits-1;
  }
  if(model=="model8") {
    evolution=model::model8;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar") {
    evolution=model::modelVar;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar1") {
    evolution=extra_model::modelVar1;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar2") {
    evolution=extra_model::modelVar2;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar3") {
    evolution=extra_model::modelVar3;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar4") {
    evolution=extra_model::modelVar4;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar5") {
    evolution=extra_model::modelVar5;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar6") {
    evolution=extra_model::modelVar6;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar7") {
    evolution=extra_model::modelVar7;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar8") {
    evolution=extra_model::modelVar8;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar9") {
    evolution=extra_model::modelVar9;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar10") {
    evolution=extra_model::modelVar10;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar11") {
    evolution=extra_model::modelVar11;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar12") {
    evolution=extra_model::modelVar12;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar13") {
    evolution=extra_model::modelVar13;
    nqubits_env=nqubits-1;
  }
  if(model=="modelVar14") {
    evolution=extra_model::modelVar14;
    nqubits_env=nqubits-1;
  }
  if(model=="modelConexComplete") {
    evolution=extra_model::modelConexComplete;
    nqubits_env=nqubits-1;
  }
  if(model=="modelConexRand") {
    evolution=extra_model::modelConexRand;
    nqubits_env=nqubits-1;
    
    ifstream con;
    con.open("conexiones.txt");
    int len, nada;
    
    con >> len >> nada;
    
    itpp::ivec conX(len);
    
    conxA=conX;
    conxB=conX;
    for(int i=0;i<len;i++) {
      con >> conxA(i) >> conxB(i);
    }
    con.close();
  }
  if(model=="modelConexRandB") {
    evolution=extra_model::modelConexRandB;
    nqubits_env=nqubits-1;
    
    ifstream con;
    con.open("conexiones.txt");
    int len, nada;
    
    con >> len >> nada;
    
    itpp::ivec conX(len);
    
    conxA=conX;
    conxB=conX;
    for(int i=0;i<len;i++) {
      con >> conxA(i) >> conxB(i);
    }
    con.close();
  }  
  if(model=="modelConexRandABC") {
    evolution=extra_model::modelConexRandABC;
    nqubits_env=nqubits-1;
    
    ifstream con;
    con.open("conexiones.txt");
    int len, nada;
    
    con >> len >> nada;
    
    itpp::ivec conX(len);
    
    conxA=conX;
    conxB=conX;
    for(int i=0;i<len;i++) {
      con >> conxA(i) >> conxB(i);
    }
    con.close();
  }
  if(model=="model3_open_VarMagnetic") {
    evolution=extra_model::model3_open_VarMagnetic;
    nqubits_env=nqubits-1;
  }

  
  int Cseed=CseedArg.getValue();int PARAMseed=PARAMseedArg.getValue();int Eseed=EseedArg.getValue();
  
  if (Cseed == 0 ){
    Random seed_uran1; 
    Cseed=seed_uran1.strong();
  }
  itpp::RNG_reset(Cseed);
  //ESTADO INICIAL C
  itpp::cvec cstate = itppextmath::RandomState(2);
  
  if (Cseed == -1 ){
    cstate = itpp::ones_c(2);
    cstate=cstate*(1/sqrt(2));
  }
  
  if (Eseed == 0 ){
    Random seed_uran3; 
    Eseed=seed_uran3.strong();
  }
  itpp::RNG_reset(Eseed);
  
  itpp::cvec state;
  if(xlen==0) {
    itpp::cvec estate = itppextmath::RandomState(l/2);
  
    //Preparacion estado inicial
    state=tensor_prod(cstate,estate);
  }
  else {
    xl=pow(2,xlen);
    itpp::cvec estateA = itppextmath::RandomState(xl);
    itpp::cvec estateB = itppextmath::RandomState(l/(xl*2));
  
    //Preparacion estado inicial
    state=tensor_prod(cstate,tensor_prod(estateB,estateA)); 
  }
  
  //PARAMETROS SEED
  if (PARAMseed == 0 ){
    Random seed_uran2; 
    PARAMseed=seed_uran2.strong();
  }
  itpp::RNG_reset(PARAMseed);
  itpp::vec js = itpp::ones(nqubits_env)*(Js.getValue()-DJs.getValue()) + itpp::randu(nqubits_env)*(2*DJs.getValue());
  //cout<<js<<endl;
  
  itpp::vec b_one(3); b_one(0)=bx.getValue(); b_one(1)=by.getValue(); b_one(2)=bz.getValue();
  //CAMPO MAGNETICO NO UNIFORME
  itpp::mat b(nqubits,3);
  if (Dbs.getValue() == -1) {
    //Caso de campo paralelo
    for(int i=0;i<nqubits;i++) { 
      b(i,0)=b_one(0);
      b(i,1)=0;
      b(i,2)=b_one(2);
      if (i<xlen) {
	b(i,0)=0;
      }
    }
  }
  else if (Dbs.getValue() == -2) {
    //Caso de campo perpendicular
    for(int i=0;i<nqubits;i++) { 
      b(i,0)=b_one(0);
      b(i,1)=0;
      b(i,2)=b_one(2);
      if (i<xlen) {
	b(i,2)=0;
      }
    }
  }  
  else {
    for(int i=0;i<nqubits;i++) { 
      b(i,0)=b_one(0)-Dbs.getValue() + itpp::randu()*2*Dbs.getValue();
      b(i,1)=0;
      b(i,2)=b_one(2)-Dbs.getValue() + itpp::randu()*2*Dbs.getValue();
    }
  }
    
  //itpp::cvec state = itppextmath::RandomState(l);
  
  //Comprobando que sea unitario al principio
  //cout<<"NORMA "<<itpp::norm(state)<<endl;
  
  
  //Se sube el estado al dev
  double *dev_R,*dev_I;
  evcuda::itpp2cuda_malloc(state,&dev_R,&dev_I);
  
  if(option=="purity") {
    for(int it=0;it<numt;it++) {
      cout<<std::real(evmath::purity_last_qubit(state,l))<<" ";
      
      //       itpp::cmat rho = evmath::reduced_densMat(dev_R,dev_I,l/2-1,nqubits);
      //       rho=rho*rho;
      //       
      //       cout<<itpp::trace(rho)<<endl;
      
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
      
      evcuda::cuda2itpp(state,dev_R,dev_I);
      
      
    }
    cout<<endl;
  }
  
  if(option=="purity_onet") {
    for(int it=0;it<numt;it++) {
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
    }
    evcuda::cuda2itpp(state,dev_R,dev_I);
    cout<<std::real(evmath::purity_last_qubit(state,l))<<endl;
  }
  
    if(option=="densMat") {
    for(int it=0;it<numt;it++) {
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
    }
    evcuda::cuda2itpp(state,dev_R,dev_I);
    itpp::cmat rho= itpp::zeros_c(2,2); 
    itpp::cvec a=state.right(l/2);
    itpp::cvec b=state.left(l/2); 
  
    rho(0,0)=itpp::dot(a,itpp::conj(a));
    rho(0,1)=itpp::dot(a,itpp::conj(b));
    rho(1,0)=itpp::dot(b,itpp::conj(a));
    rho(1,1)=itpp::dot(b,itpp::conj(b));
    cout<<rho(0,0)<<" "<<rho(0,1)<<" "<<rho(1,0)<<" "<<rho(1,1)<<endl;
    
    rho=rho*rho;
//     cout<<"P = "<<itpp::trace(rho);
  }
  
  if(option=="purity_gamma") {
    itpp::cvec zerostate=state;
    int div=150;
    for(int gi=0;gi<=div;gi++) {
      double Jpi=((itpp::pi*gi)/(div+1))/sqrt(Jp);
      evcuda::itpp2cuda(zerostate,dev_R,dev_I);
      for(int it=0;it<numt;it++) {
        evolution(dev_R,dev_I,js,J,Jpi,b,nqubits,xlen,conxA,conxB);
      }
      cudaCheckError("valio verga",383);
      evcuda::cuda2itpp(state,dev_R,dev_I);
      cout<<std::real(evmath::purity_last_qubit(state,l))<<endl;
    }
  }
  
  if(option=="purity_all_systems") {
    int whichA,whichB,whichC;
    itpp::cmat rhoA,rhoB;
    for(int it=0;it<numt;it++) {
      //cout<<std::real(evmath::purity_last_qubit(state,l))<<endl;
      
      whichC=l/2;
      whichA=xl-1;
      whichB=(l-1)^(whichA^whichC);
            
      rhoA = evmath::reduced_densMat(dev_R,dev_I,whichA,nqubits);
      rhoB = evmath::reduced_densMat(dev_R,dev_I,whichB,nqubits);
      //rhoC = evmath::reduced_densMat(dev_R,dev_I,whichC,nqubits);
      
      rhoA=rhoA*rhoA;
      rhoB=rhoB*rhoB;
      //rhoC=rhoC*rhoC;

      cout<<real(trace(rhoA))<<" "<<real(itpp::trace(rhoB))<<" "<<real(evmath::purity_last_qubit(state,l))<<endl;
      
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
      
      evcuda::cuda2itpp(state,dev_R,dev_I);
      
      
    }
  }
  
  if(option=="purity_timeavg") {
    itpp::vec purities(100);
    itpp::cvec zerostate=state;
    int div=300;
    for(int ij=0;ij<=div;ij++) {
      double Ji=((itpp::pi*ij)/div);
      evcuda::itpp2cuda(zerostate,dev_R,dev_I);
      for(int i=0;i<100;i++) {
	evolution(dev_R,dev_I,js,J,Ji,b,nqubits,xlen,conxA,conxB);
      }
      for(int i=0;i<100;i++) {
	evcuda::cuda2itpp(state,dev_R,dev_I);
	evolution(dev_R,dev_I,js,J,Ji,b,nqubits,xlen,conxA,conxB);
	purities(i)=std::real(evmath::purity_last_qubit(state,l));
      }
      cout<<Ji<<" "<<itpp::mean(purities)<<" "<<std::sqrt(itpp::variance(purities))<<endl;    
    }
    cout<<endl;
  }
  
  if(option=="test_Umat") {
    itpp::cmat U;
    if(symr.getValue()==1) {
      U = evmath::evolution_matrix_chain_reflection(J,b.get_row(0),nqubits,1);
    }
    else { 
      U = evmath::evolution_matrix_chain_translation(J,b.get_row(0),nqubits,1);
    }
    int rcont = U.rows();
    //Prueba unitariedad
    cout<<itpp::norm(itpp::eye_c(rcont)-U*itpp::hermitian_transpose(U))<<endl;
    //Prueba de evoluciones
    itpp::cvec state2 = U * state;
    evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
    evcuda::cuda2itpp(state,dev_R,dev_I);
    cout<<itpp::norm(state-state2)<<endl;  
  }
  
  if(option=="get_spectra") {
    itpp::cmat U;
    if(symr.getValue()==0) {
      U = evmath::evolution_matrix_chain_reflection(J,b.get_row(0),nqubits,1);
    }
    else { 
      U = evmath::evolution_matrix_chain_translation(J,b.get_row(0),nqubits,1);
    }
    int rcont = U.rows();
    itpp::cvec eigenvalues(rcont);
    itpp::cmat eigenvectors(rcont,rcont);
    itpp::eig(U,eigenvalues,eigenvectors);
    
    for(int i=0;i<rcont;i++) {
      cout<<argument(eigenvalues(i))<<endl;
    }
    
    //Calculo del error
    //double error=itpp::norm(U-eigenvectors*itpp::diag(eigenvalues)*itpp::hermitian_transpose(eigenvectors));
    //cout<<"ERROR "<<error<<endl;
  }  
  
  if(option=="correlation") {
    double *dev_sumdxR,*dev_sumdxI;
    evcuda::cmalloc(&dev_sumdxR,&dev_sumdxI,l);
    double *dev_inR,*dev_inI;
    evcuda::cmalloc(&dev_inR,&dev_inI,l);
    
    evcuda::itpp2cuda(state,dev_R,dev_I);
    
    int numthreads;
    int numblocks;
    choosenumblocks(l,numthreads,numblocks); 
    
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits,l);
    itpp::cvec sumstate(l);
    
    evcuda::cuda2itpp(sumstate,dev_sumdxR,dev_sumdxI);
    evcuda::cuda2itpp(state,dev_inR,dev_inI);
    
    
    for(int it=0;it<numt;it++) {
      sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits,l);
      evcuda::cuda2itpp(sumstate,dev_sumdxR,dev_sumdxI);
      evcuda::cuda2itpp(state,dev_inR,dev_inI);
      
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
      evolution(dev_inR,dev_inI,js,J,Jp,b,nqubits,xlen,conxA,conxB);
      
      cout<<sqrt(std::norm(itpp::dot(itpp::conj(sumstate),state)))/nqubits<<endl;
    }
    
    cudaFree(dev_sumdxR);
    cudaFree(dev_sumdxI);
    
  }
  
  if(option=="corr_map") {
    double *dev_sumdxR,*dev_sumdxI;
    evcuda::cmalloc(&dev_sumdxR,&dev_sumdxI,l);
    double *dev_inR,*dev_inI;
    evcuda::cmalloc(&dev_inR,&dev_inI,l);
    
    itpp::vec correlations(20);
    itpp::cvec zerostate=state;
    itpp::cvec sumstate=state;
    evcuda::itpp2cuda(state,dev_R,dev_I);
    
    int numthreads;
    int numblocks;
    choosenumblocks(l,numthreads,numblocks); 
    
    int div=250;
    double bxi,bzi;
    for(int idiv=0;idiv<div;idiv++) {
      bxi=((2*itpp::pi*idiv)/div);
      for(int jdiv=0;jdiv<div;jdiv++) {
	evcuda::itpp2cuda(zerostate,dev_R,dev_I);
	sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_inR,dev_inI,nqubits,l);
	
	bzi=((2*itpp::pi*jdiv)/div);
	b(0)=bxi; b(2)=bzi;
	
	for(int i=0;i<80;i++) {
	  evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
	  evolution(dev_inR,dev_inI,js,J,Jp,b,nqubits,xlen,conxA,conxB);
	}
	
	for(int i=0;i<20;i++) {
	  sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits,l);
	  
	  evcuda::cuda2itpp(sumstate,dev_sumdxR,dev_sumdxI);
	  evcuda::cuda2itpp(state,dev_inR,dev_inI);
	  
	  evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
	  evolution(dev_inR,dev_inI,js,J,Jp,b,nqubits,xlen,conxA,conxB);
	  
	  correlations(i)=sqrt(std::norm(itpp::dot(itpp::conj(sumstate),state)))/nqubits;
	}
	cout<<bxi<<" "<<bzi<<" "<<itpp::mean(correlations)<<" "<<std::sqrt(itpp::variance(correlations))<<endl;    
      }
    }
    
    cudaFree(dev_sumdxR);
    cudaFree(dev_sumdxI);
  }
  
  if(option=="trU") {
    
    itpp::cvec stateBra=state; 
    for(int t=0;t<numt;t++) {
      evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
      evcuda::cuda2itpp(state,dev_R,dev_I);
      cout<<t+1<<" "<<norm(itpp::dot(itpp::conj(stateBra),state))<<endl;  
    }
  }
  
  
  
  if(option=="carlostest_chain") {
    itpp::cvec cstate = state;
    //CUDA evolution
    evolution(dev_R,dev_I,js,J,Jp,b,nqubits,xlen,conxA,conxB);
    evcuda::cuda2itpp(state,dev_R,dev_I);
    //Carlos evolution
    for(int i=0;i<nqubits;i++) {
      spinchain::apply_ising_z(cstate,js(i),i,(i+1)%nqubits);
    }
    for(int i=0;i<nqubits;i++) {
      spinchain::apply_magnetic_kick(cstate,b_one,i);
    }
    
    cout<<itpp::norm(state-cstate)<<endl; 
  }
  
  if(option=="carlostest_sumdx") {
    double *dev_sumdxR,*dev_sumdxI;
    evcuda::cmalloc(&dev_sumdxR,&dev_sumdxI,l);
    
    int numthreads;
    int numblocks;
    choosenumblocks(l,numthreads,numblocks);
    
    itpp::cvec cstate = state;
    
    //CUDA evolution
    //evcuda::apply_sumdx(nqubits,dev_R,dev_I,dev_sumdxR,dev_sumdxI);
    sumsigma_x<<<numblocks,numthreads>>>(dev_R,dev_I,dev_sumdxR,dev_sumdxI,nqubits,l);
    evcuda::cuda2itpp(state,dev_sumdxR,dev_sumdxI);
    //Carlos evolution
    itpp::cmat sumsig=itpp::zeros_c(l,l);
    b_one(0)=1.; b_one(1)=0.; b_one(2)=0.;
    
    for(int i=0;i<nqubits;i++) {
      sumsig+=itppextmath::sigma(b_one,i,nqubits);
    }
    cstate=sumsig*cstate;
    cout<<itpp::norm(state-cstate)<<endl; 
    cout<<itpp::norm(state)<<endl;
    cout<<itpp::norm(cstate)<<endl;
    
    
    cudaFree(dev_sumdxR);
    cudaFree(dev_sumdxI);
    
  }
  
  cudaFree(dev_R);
  cudaFree(dev_I);
  
  
}




