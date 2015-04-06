#include <iostream>
#include <itpp/itbase.h>
#include <cpp/dev_random.cpp>
#include <cpp/itpp_ext_math.cpp>
#include <cpp/spinchain.cpp>
#include <math.h>
#include <tclap/CmdLine.h>
#include "tools.cpp"
#include <time.h>

// TCLAP::CmdLine cmd("Command description message", ' ', "0.1");
// TCLAP::ValueArg<int> num_a("","a", "Some int",false, 0,"int",cmd);
// TCLAP::ValueArg<int> num_b("","b", "Some int",false, 0,"int",cmd);

using namespace std;

//PARA COMPILAR
// g++ -I ../libs/ pru.cpp -o pru -litpp

int main(int argc,char* argv[]) {
//   cmd.parse(argc,argv);
  // Set initial stuff


//   //cout<<bit_reflection_h2(num_a.getValue(),num_b.getValue())<<endl;
//   
//   int l = pow(2,num_a.getValue());
//   int *S=new int[l];
//   for(int m=0;m<l;m++) {
//     S[m]=2;
//   }
//   find_states_reflection(S,num_a.getValue(),num_b.getValue(),l);
//   int rcont=0;
//   
//   for(int i=0;i<l;i++) {
//     if(S[i]==1) {
//       cout<<i<<endl;
//       S[rcont]=i;
//       rcont++;
//     }
//   }
//   
//   
//   //itpp::cmat sumsig=itpp::zeros_c(6,6);
//   
//   //cout<<sumsig(2)<<endl;
  
  
// itpp::imat conexx=conexiones(10,6,10);
  
  
  itpp::ivec conA,conB;
  

ifstream con;
    con.open("conexiones.txt");
    
    int len, nada;
    
    con >> len >> nada;
    
    itpp::ivec conX(len);
    
    conA=conX;
    conB=conX;
    
    for(int i=0;i<len;i++) {
      con >> conA(i) >> conB(i);
    }
    con.close();

    cout<<conA<<endl;
    cout<<conB<<endl;
    
}
  
  
  
