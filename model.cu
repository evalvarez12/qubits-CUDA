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
              *  last qubit - not kicked
          
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
  for(int i=0;i<nqubits-1;i++) {
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
              *  last qubit - not kicked
          
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
  Ui_kernel<<<numblocks,numthreads>>>(0,xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen/2-1,nqubits-xlen,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen/2+1,nqubits-xlen+1,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(xlen-1,nqubits-2,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,xlen/2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model5(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 5 CLOSED
       
  <- *   *   *   *   *   *  ->
      \   \   \   \   \   \
   <-  *   *   *   *   *   * ->
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
  //la interaccion A B es 1 a 1 
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+xlen,dev_R,dev_I,cos(jp),sin(jp),l);
    } 
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
  
void model5_open(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 5 OPEN
       
  *   *   *   *   *   * 
   \   \   \   \   \   \
    *   *   *   *   *   *
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
  //la interaccion A B es 1 a 1 
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+xlen,dev_R,dev_I,cos(jp),sin(jp),l);
    } 
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model6(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 6 CLOSED
 <-*   *   *   *   *   *  ->    
    \     /     \     /
  <- *   *   *   *   *   *  ->
      \       \     /     \
   <-  *   *   *   *   *   * ->
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
  //la interaccion A B es 1 a 1 
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+xlen,dev_R,dev_I,cos(jp),sin(jp),l);
    } 
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,0,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
  
void model7(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 7 CASO ESPECIAL
       
  *   *   *   *   *   *   *
       \     /   /   /
        *   *   *   * 
             \      
              *  last qubit - not kicked
         PARA A=6 B=10       
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
  Ui_kernel<<<numblocks,numthreads>>>(0,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,15,dev_R,dev_I,cos(jp),sin(jp),l);
  //CONEXIONES EXTRA A B
  //Ui_kernel<<<numblocks,numthreads>>>(0,7,dev_R,dev_I,cos(jp),sin(jp),l);
  //Ui_kernel<<<numblocks,numthreads>>>(1,8,dev_R,dev_I,cos(jp),sin(jp),l);
  //Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //Ui_kernel<<<numblocks,numthreads>>>(3,11,dev_R,dev_I,cos(jp),sin(jp),l);
  //Ui_kernel<<<numblocks,numthreads>>>(4,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,14,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
  
void model8(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL 8 CASO ESPECIAL
       
  *   *   *   *   *   *   *
       \     /   /   /
        *   *   *   * 
             \      
              *  last qubit - not kicked
         PARA A=10 B=15       
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
  Ui_kernel<<<numblocks,numthreads>>>(0,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,17,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,18,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(6,19,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(7,21,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(8,23,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(9,25,dev_R,dev_I,cos(jp),sin(jp),l);
  //INTERACCIONES EXTRA A B
/*  Ui_kernel<<<numblocks,numthreads>>>(0,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,16,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,16,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,19,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(6,20,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(7,20,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(8,22,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(9,24,dev_R,dev_I,cos(jp),sin(jp),l); */ 
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,6,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void modelVar(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
  /*    MODEL VARIABLE CASO ESPECIAL
       
  *   *   *   *   *   *   *
       \     /   /   /
        *   *   *   * 
             \      
              *  last qubit - not kicked
         PARA A=6 B=10       
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
  //la interaccion variable  A B  
  Ui_kernel<<<numblocks,numthreads>>>(0,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,15,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
    
 
} 

#endif    