#ifndef EXMODEL
# define EXMODEL

namespace extra_model{

void modelVar1(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar2(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar3(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar4(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar5(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar6(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar7(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar8(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar9(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar10(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar11(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar12(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar13(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelVar14(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
  Ui_kernel<<<numblocks,numthreads>>>(0,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(0,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,14,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(1,11,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,9,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,7,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(2,6,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,13,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(3,12,dev_R,dev_I,cos(jp),sin(jp),l);
  Ui_kernel<<<numblocks,numthreads>>>(4,15,dev_R,dev_I,cos(jp),sin(jp),l);
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
void modelConexComplete(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
void modelConexRand(double *dev_R, double *dev_I, itpp::vec js, double j, double jp, itpp::mat b , int nqubits, int xlen){ 
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
  int num_conex=10;
  itpp::imat conexiones=itpp::zeros_i(xlen,nqubits-xlen-1);
  int ac=itpp::randi(0,xlen-1);
  int bc=itpp::randi(xlen,nqubits-2);
  for(int i=0;i<=num_conex;i++) {
    while(conexiones(ac,bc-xlen)==1) {
      ac=itpp::randi(0,xlen-1);
      bc=itpp::randi(xlen,nqubits-2);
      }
    Ui_kernel<<<numblocks,numthreads>>>(ac,bc,dev_R,dev_I,cos(jp),sin(jp),l);
    conexiones(ac,bc-xlen)=1;
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

  

} 

#endif    