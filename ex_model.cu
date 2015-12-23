#ifndef EXMODEL
# define EXMODEL

namespace extra_model{

void modelVar1(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(3,14,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar2(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,7,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar3(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(1,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,14,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar4(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,13,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar5(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,14,dev_R,dev_I,cos(jp),sin(jp),l);
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
void modelVar6(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(1,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,11,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar7(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,6,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar8(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,12,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar9(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(1,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,14,dev_R,dev_I,cos(jp),sin(jp),l);
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
void modelVar10(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,6,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar11(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,9,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar12(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,12,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelVar13(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,15,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,10,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,8,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(5,13,dev_R,dev_I,cos(jp),sin(jp),l);
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
void modelVar14(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);

  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelConexComplete(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  //la interaccion COMPLETA  A B  
  for(int i=0;i<xlen;i++) {
    for(int j=xlen;j<nqubits-1;j++) {
      Ui_kernel<<<numblocks,numthreads>>>(i,j,dev_R,dev_I,cos(jp),sin(jp),l);
    }
  }
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
void modelConexRand(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  //la interaccion VARIABLE  A B
  int num_conex=conA.size();
  for(int i=0;i<num_conex;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(conA(i),conB(i),dev_R,dev_I,cos(jp),sin(jp),l);
  }
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void modelConexRandB(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  //se hace la interacion A con B
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);  
  //la interaccion VARIABLE  0 A
  int num_conex=conA.size();
  for(int i=0;i<num_conex;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(conA(i),conB(i),dev_R,dev_I,cos(j),sin(j),l);
  }
  
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
  
void modelConexRandABC(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  //la interaccion VARIABLE  ABC
  int num_conex=conA.size();
  for(int i=0;i<num_conex;i++) {
    if (conA(i) == nqubits-1) {
      Ui_kernel<<<numblocks,numthreads>>>(conA(i),conB(i),dev_R,dev_I,cos(j),sin(j),l);
    }
    else {
      Ui_kernel<<<numblocks,numthreads>>>(conA(i),conB(i),dev_R,dev_I,cos(jp),sin(jp),l);
    }
  }
  
  //evolucion patada magnetica
  for(int i=0;i<nqubits;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }  
  
void model3_open_op1(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }  
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model3_open_op2(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(3,5,dev_R,dev_I,cos(js(1)),sin(js(1)),l);
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }
  Ui_kernel<<<numblocks,numthreads>>>(7,11,dev_R,dev_I,cos(js(6)),sin(js(6)),l);
  Ui_kernel<<<numblocks,numthreads>>>(9,14,dev_R,dev_I,cos(js(9)),sin(js(9)),l);
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }   

void model3_open_op3(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(1,3,dev_R,dev_I,cos(js(1)),sin(js(1)),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,5,dev_R,dev_I,cos(js(3)),sin(js(3)),l);
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }
  Ui_kernel<<<numblocks,numthreads>>>(6,8,dev_R,dev_I,cos(js(6)),sin(js(6)),l);
  Ui_kernel<<<numblocks,numthreads>>>(7,14,dev_R,dev_I,cos(js(7)),sin(js(7)),l);  
  Ui_kernel<<<numblocks,numthreads>>>(9,12,dev_R,dev_I,cos(js(8)),sin(js(8)),l);
  Ui_kernel<<<numblocks,numthreads>>>(12,15,dev_R,dev_I,cos(js(9)),sin(js(9)),l);
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model3_open_op4(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(2,4,dev_R,dev_I,cos(js(1)),sin(js(1)),l);
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }
  Ui_kernel<<<numblocks,numthreads>>>(7,10,dev_R,dev_I,cos(js(6)),sin(js(6)),l);
  Ui_kernel<<<numblocks,numthreads>>>(10,14,dev_R,dev_I,cos(js(9)),sin(js(9)),l);
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
  
void model3_open_op5(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,2,dev_R,dev_I,cos(js(3)),sin(js(3)),l);    
  Ui_kernel<<<numblocks,numthreads>>>(2,4,dev_R,dev_I,cos(js(1)),sin(js(1)),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,5,dev_R,dev_I,cos(js(4)),sin(js(4)),l);
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }
  Ui_kernel<<<numblocks,numthreads>>>(6,10,dev_R,dev_I,cos(js(6)),sin(js(6)),l);  
  Ui_kernel<<<numblocks,numthreads>>>(8,10,dev_R,dev_I,cos(js(7)),sin(js(7)),l);
  Ui_kernel<<<numblocks,numthreads>>>(10,13,dev_R,dev_I,cos(js(9)),sin(js(9)),l);
  Ui_kernel<<<numblocks,numthreads>>>(11,15,dev_R,dev_I,cos(js(12)),sin(js(12)),l);
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  }
 
void model3_open_op6(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,2,dev_R,dev_I,cos(js(1)),sin(js(1)),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,4,dev_R,dev_I,cos(js(3)),sin(js(3)),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,5,dev_R,dev_I,cos(js(4)),sin(js(4)),l);
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(jp),sin(jp),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
  return;  
  } 
  
void model3_open_VarMagnetic(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen,itpp::ivec conA, itpp::ivec conB){ 
  /*    MODEL 3 OPEN
       
      *   *   *   *   *   *   *  
             /      
        *   *   *   * 
             \      
              *  last qubit - not kicked
          
  */
  int numthreads, numblocks;
  double kcos,ksin,bx,by,bz;
  double kcosC,ksinC,bxC,byC,bzC;
  int l=pow(2,nqubits);
  
  double JP_real = .8;
  
  itpp::vec bC(3);
  choosenumblocks(l,numthreads,numblocks);
  //la evolucion de la cadena A de tamaño xlen
  for(int i=0;i<xlen-1;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i,i+1,dev_R,dev_I,cos(js(i)),sin(js(i)),l);
    }
  //la evolucion de la cadena B de tamaño nqubits - xlen - 1  
  for(int i=0;i<nqubits-2-xlen;i++) {
    Ui_kernel<<<numblocks,numthreads>>>(i+xlen,i+1+xlen,dev_R,dev_I,cos(js(i+xlen)),sin(js(i+xlen)),l);
    }  
  //la interaccion A B  
  Ui_kernel<<<numblocks,numthreads>>>(2,10,dev_R,dev_I,cos(JP_real),sin(JP_real),l);
  //se hace la interacion 0 con A
  Ui_kernel<<<numblocks,numthreads>>>(nqubits-1,2,dev_R,dev_I,cos(j),sin(j),l);
  //evolucion patada magnetica
  for(int i=0;i<nqubits-1;i++) {
    set_parameters(b.get_row(i),kcos,ksin,bx,by,bz);
    Uk_kernel<<<numblocks,numthreads>>>(i,dev_R,dev_I,bx,by,bz,kcos,ksin,l);     
    }
    bC(0)=jp/std::sqrt(2.); bC(1)=0.; bC(2)=jp/std::sqrt(2.);
    set_parameters(bC,kcosC,ksinC,bxC,byC,bzC);
    Uk_kernel<<<numblocks,numthreads>>>(nqubits-1,dev_R,dev_I,bxC,byC,bzC,kcosC,ksinC,l);
  return;  
  }  
  

} 

#endif    