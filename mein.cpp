 // {{{ includes,  namespaces, TCLAP (command line options) and OpenMP (parallel processing).
// Compilation: g++ -o Lambda Lambda.cpp -litpp -fopenmp
#include <itpp/itbase.h>
#include <itpp/stat/misc_stat.h>
#include <cpp/cfp_math.cpp>
#include <cpp/itpp_ext_math.cpp>
#include <cpp/RMT.cpp>
#include <tclap/CmdLine.h>
#include <cpp/dev_random.cpp>
#include <cstdio>
#include <ctime>

using namespace std;
using namespace itpp;
using namespace itppextmath;
using namespace cfpmath;

  TCLAP::CmdLine cmd("Command description message", ' ', "0.1");
  TCLAP::ValueArg<string> optionArg("o","option", "Option"
      ,false,"nichts", "string",cmd);
  TCLAP::ValueArg<unsigned int> seed("s","seed",
      "Random seed [0 for urandom]",false, 243243,"unsigned int",cmd);
  // "Random seed [0 for urandom]",false, 938475975,"unsigned int",cmd);
  TCLAP::ValueArg<int> dimension_a("","dimension-a", "Dimension of the subsystem a",false, 2,"int",cmd);
  TCLAP::ValueArg<int> dimension_b("","dimension-b", "Dimension of the subsystem b",false, 6,"int",cmd);
  TCLAP::ValueArg<int> dimension_c("","dimension-c", "Dimension of the subsystem c",false, 6,"int",cmd);
  TCLAP::ValueArg<int> time_steps("t","time_steps", "Number of time steps",false, 20,"int",cmd);
  TCLAP::ValueArg<double> lambda("","lambda",
      "Coupling of the central system to a part of the environment V_coupling = lambda V_bc ",false, .1,"double",cmd);
  TCLAP::ValueArg<double> theta("","theta",
      "Modulator to change from a global environment to a separate one H_env=cos theta(H_a + H_b)+sin theta(V_ab)",false, pi/2,"double",cmd);
  TCLAP::ValueArg<double> gammaARG("","gamma",
      "Coupling within the environment gamma V_ab",false, .1,"double",cmd);
  TCLAP::ValueArg<double> ensamble_size("","ensamble_size",
      "Number of random trajectories",false, 1000,"long",cmd);
  TCLAP::ValueArg<double> total_time("","total_time", "Total time of evolution",false, 10.,"double",cmd);
  //           "Number of particles per dimension",false, 9,"int",cmd);
  TCLAP::SwitchArg no_general_report("","no_general_report",
      "Print the general report", cmd);
// }}}
vec allpurities(cvec& psi, int n_middle, int n_last){ // {{{
  vec purities(3);
  int n_first = psi.size()/(n_middle * n_last);
  cmat rho;
//   cout << "Estado de entrada: " << psi << endl;

  rho = partial_trace(psi, n_last);
  purities(2) = Purity(rho);

//   cout << "rho_last: " << rho << endl;

  ReorderTwoSubsystems(psi, n_last);
//   cout << "Estado al reordenar (0+1): " << psi << endl;
  rho = partial_trace(psi, n_middle); 
  purities(1) = Purity(rho);
//   cout << "rho_middle: " << rho << endl;
//   abort();


  ReorderTwoSubsystems(psi, n_middle);
  rho = partial_trace(psi, n_first);
  purities(0) = Purity(rho);
//   cout << "rho_first: " << rho << endl;

  ReorderTwoSubsystems(psi, n_first);
  return purities;
} // }}}
cmat Hamiltonian_CBA(int dimension_Hc, int dimension_Hb, int dimension_Ha, double theta, double gamma, double lambda){ // {{{
      // H = cos theta(H_a + H_b) + H_c + sin theta(gamma V_ab) + lambda V_bc
      // parametros na, nb, y nc, las dimensiones de los sistemas
      // theta, que me modula el 
  //
  // La estructura del espacio de Hilbert es 
  // H = \mcH_c \otimes \mcH_b \otimes \mcH_a
  int na= dimension_Ha;
  int nb= dimension_Hb;
  int nc= dimension_Hc;
  cmat Ha  = RMT::RandomGUE(na)/sqrt(double(na));
  cmat Hb  = RMT::RandomGUE(nb)/sqrt(double(nb));
  cmat Hc  = RMT::RandomGUE(nc)/sqrt(double(nc));
  cmat Vab = RMT::RandomGUE(na*nb)/sqrt(double(na*nb));
  cmat Vbc = RMT::RandomGUE(nb*nc)/sqrt(double(nb*nb));
  cmat Ia  = eye_c(na);
  cmat Ib  = eye_c(nb);
  cmat Ibc = eye_c(nb*nc);
  cmat Ic  = eye_c(nc);
  cmat H, Henv;

  Henv = cos(theta)*(prepend_tensor_identity(Ha,nb) + postpend_tensor_identity(Hb, na)) + sin(theta)*gamma* Vab;
  H = postpend_tensor_identity(Hc, na*nb)
        + prepend_tensor_identity(Henv,nc)
        + lambda * postpend_tensor_identity(Vbc, na);
  return H;
} //}}}
int main(int argc, char* argv[]){ // {{{
  // {{{ initial definitions
  //freopen ("output2.out", "w", stdout);//write to file with standard I/O commands
  cmd.parse( argc, argv );
  int error=0;
  long N = ensamble_size.getValue();
  string option=optionArg.getValue();
  cout.precision(17); cerr.precision(17);
  std::complex<double> I(0.,1.);
  // }}}
  // {{{ Set seed for random
  unsigned int semilla=seed.getValue();
  if (semilla == 0){
    Random semilla_uran; semilla=semilla_uran.strong();
  } 
  RNG_reset(semilla);
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
  if //{{{ Here the main options to run the program 
    (option == "get_purity"){ // {{{
      int nc = dimension_c.getValue(), nb = dimension_b.getValue(), na = dimension_a.getValue();
      double t;
      vec eigenvalues;
      cmat W;
      vec ps;

      cmat H = Hamiltonian_CBA(nc, nb, na, theta.getValue(), gammaARG.getValue(), lambda.getValue());
      eig_sym(H,eigenvalues,W); // Calculates the eigenvalues and eigenvectors (complexity O(n^3))

      cvec psi_0= TensorProduct(BasisState(nc,0),TensorProduct(RandomState(nb),BasisState(na,0))), psi_t ;
      cvec Wdagger_psi_0 = hermitian_transpose(W)*psi_0, psi_n;

//       Testing  {{{
//       cvec psi_t_long;
//       psi_t_long = exponentiate(-I* t * H)*psi_0; //
//       cout << norm(psi_t_long - psi_t) << endl;
//       }}}

      for (int it=0; it < time_steps.getValue(); it++){
        t = it * total_time.getValue() / time_steps.getValue();
        psi_t = W*elem_mult(exp(-I*eigenvalues*t),Wdagger_psi_0);
        ps=allpurities(psi_t, nb, na);
        cout << t<< " "<< ps(0) << " "<< ps(1) << " "<< ps(2) << endl;
      }
    // }}}
  } else { // {{{
    cout << "Error en la opcion. Mira, esto es lo que paso: "
      << optionArg.getValue() << endl;
  } // }}}
  // }}}
  // {{{ Final report
  if(!no_general_report.getValue()){
    error += system("echo \\#terminando:    $(date)");
  }
  // }}}
  return 0;
} // }}}



//Una cadena de 2,3,4,5,6,.. qubits unida a un spin solo por solo un
//spin fuertemente.   selligman44@gmail.com selligman44. con parametros 
//coaticos de la cadena.

//si hay problemas con simetria unir dos elementos de la cadena aleatorios.
// buscar conacyt sni para buscar de beca. o por internet.

//