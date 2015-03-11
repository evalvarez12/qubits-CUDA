#ifndef MODEL
# define MODEL
# include "tools.cpp"
# include "cuda_functions.cu"
namespace model{
 
void model1(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int extra){ 
  /*      MODEL 1
             *
           *   *   
          *     * -- * last qubit
           *   *
             *
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  for(int i=0;i<nqubits-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(nqubits-1),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //se hace la interacion 0 con ultimo
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model11(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int extra){ 
  /*      MODEL 1.1
             *
           * | *   
          *  |  * -- * last qubit
           * | *
             *
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  //la interaccion cruzada dentro de la cadena
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-2,2,dev_R,dev_I,cos(js(nqubits/2)),sin(js(nqubits/2)),l);
  for(int i=0;i<nqubits-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(nqubits-1),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //se hace la interacion 0 con ultimo
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  

void model2(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int extra){ 
  /*      MODEL 2
             *
           *   * - 
          *     * - * last qubit
           *   * - 
             *
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  for(int i=0;i<nqubits-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(nqubits-1),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //se hace la interacion 0,1,penultimo con ultimo
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,1,dev_R,dev_I,cos(j),sin(j),l);
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,nqubits-2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
  
void chain(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int extra){ 
  /*    MODEL CHAIN CLOSED
             *
           *   * 
          *     * 
           *   * 
             *
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  for(int i=0;i<nqubits;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(nqubits),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
  
  
void chain_open(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int extra){ 
  /*    MODEL CHAIN OPEN

    *  *  *  *  *  *  *  *  *  
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  for(int i=0;i<nqubits-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+1,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void lattice(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL LATTICE
       
       *   *   *   *
       *   *   *   *
       *   *   *   *
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  int i_hor,i_ver;
  choosenumblocks(l,numthreads,numblocks);
  for(int i=0;i<nqubits-1;i++) {
    i_hor=(i+1)%xlen+(i/xlen)*xlen;
    i_ver=(i+xlen)%nqubits;
    Ui_kernel<<<numblocks,numthreads>>>(i,i_hor,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    Ui_kernel<<<numblocks,numthreads>>>(i,i_ver,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model3(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 3 CLOSED
       
   <- *   *   *   *   *   *   *  ->
             /      
     <- *   *   *   * -> 
             \      
              *  last qubit
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  //la evolucion de la cadena A de tamaño xlen
  for(int i=0;i<xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(xlen),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }  
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-1-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,(i+1)%(nqubits-1-xlen)+xlen,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(xlen-1,xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  } 
  
void model3_open(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 3 OPEN
       
      *   *   *   *   *   *   *  
             /      
        *   *   *   * 
             \      
              *  last qubit
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  //la evolucion de la cadena A de tamaño xlen
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+1,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }  
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(xlen-1,xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  } 
  
void model4(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 4 CLOSED
       
   <- *   *   *   *   *   *   *  ->
       \     /   /   /
     <- *   *   *   * -> 
             \      
              *  last qubit
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  //la evolucion de la cadena A de tamaño xlen
  for(int i=0;i<xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,(i+1)%(xlen),dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }  
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-1-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,(i+1)%(nqubits-1-xlen)+xlen,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //las interacciones A B  
  Ui_kernel<<<numblocks,numthreads>>>(xlen-4,xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen-2,xlen+2,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen-1,xlen+4,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  } 
  
void model4_open(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 4 OPEN
       
  *   *   *   *   *   *   *
       \     /   /   /
        *   *   *   * 
             \      
              *  last qubit
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  int l=pow(2,nqubits);
  choosenumblocks(l,numthreads,numblocks);
  //la evolucion de la cadena A de tamaño xlen
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+1,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }  
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(xlen-4,xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen-2,xlen+2,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen-1,xlen+4,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
    
    
} 

#endif    