#include "hyperbolic_cordic.h"
#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

int test_sinh_cosh(void){
	// This part is to test your correctness of sinh and cosh implementation
	// We will take a random number in range [-1, 1] as the input angle, your goal
	// is to calculate the sinh and cosh of the given input.
	srand(RAND_MAX);
	for(int i=0; i<100; i++){
		// random inputs
		data_t x = (data_t)(1-0.02*i);
		data_t sinh_out, cosh_out;
		data_t sinh_ref, cosh_ref;

		// reference results from standard library
		sinh_ref = (data_t)sinh((float)x);
		cosh_ref = (data_t)cosh((float)x);

		// output result from our implementation
		cordic_sinh_cosh(1, 0, x, sinh_out, cosh_out);

		// check the correctness of your sine and cosine
		// if the error is larger than threshold, raise error
		if(abs((float)(sinh_ref - sinh_out)) > 0.05 || abs((float)(cosh_ref - cosh_out)) > 0.05){
			cout<<"Theta x(in radius): "<<x<<endl;
			cout<<"Reference sinh(x): "<<sinh_ref<<endl;
			cout<<"Your sinh(x): "<<sinh_out<<endl;
			cout<<"Reference cosh(x): "<<cosh_ref<<endl;
			cout<<"Your cosh(x): "<<cosh_out<<endl;
			cout<<"[Error] Your implementation of hyperbolic sine and cosine are incorrect!"<<endl;
			return(-1);
		}
	}
	cout<<"[Success] Your implementation of hyperbolic sine and cosine are correct!"<<endl;
	return(0);
}

int main(){
	// declare testing functions
	int correctness = 0;
	correctness = test_sinh_cosh();

	return(0);
}
