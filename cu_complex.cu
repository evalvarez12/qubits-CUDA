#ifndef CUCOMPLEX
#define CUCOMPLEX

#include <iostream>
#include "math.h"

using namespace std;

class Complex {

  public:
  double real;
  double imag;
  __device__ Complex(double a, double b) {
    real=a;
    imag=b;
  }
  
  __device__ Complex() {
    real=0;
    imag=0;
  } 
    
  __device__ Complex operator +(Complex &c) {
    return Complex(real+c.real,imag+c.imag);
  }
  
  __device__ Complex operator -(Complex &c) {
    return Complex(real-c.real,imag-c.imag);
  }
  
  __device__ Complex operator *(Complex &c) {
    return Complex((real*c.real)-(imag*c.imag),(real*c.imag)+(imag*c.real));
  }
  
  __device__ Complex operator *(double d) {
    return Complex(real*d,imag*d);
  }
  
  __device__ double norma() {
    return sqrt(powf(real,2)+powf(imag,2));
  }
  
  __device__ Complex conjugado() {
    return Complex(real,(-1)*imag);
  }
  
};


#endif  
//CUCOMPLEX