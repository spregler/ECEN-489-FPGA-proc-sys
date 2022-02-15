/*********************************************************************/
// Description:														  /
//     C++ testbench file for checking your implementation on CORDIC. /
// 																	  /
//	   Please DO NOT modify the code. Some errors will pop up if 	  /
//	   you accidently delete something. The only part you can modify  /
//	   is the main function. You are allowed to change which function /
//	   to test on.													  /
/*********************************************************************/

#include "basic_cordic.h"
#include <iostream>
#include <iomanip>
#include <cmath>

using namespace std;

#define RAND (rand()%181) - (rand()%181)

int test_sin_cos(void){
	// This part is to test your correctness of sine or cosine implementation
	// We will take a random number in range [-180, 180] as the input angle, your goal
	// is to calculate the sine and cosine of the input angle.

	// test angles (in degree): 89, 75, 60, 40, 15, -20, -30, -55, -70, -88
	data_t test_angles[10] = {1.5533430343, 1.308996939, 1.0471975512,
							  0.6981317008, 0.261799388, -0.34906585,
							  -0.523598776, -0.95993109, -1.221730476,
							  -1.53588974};

//	srand(RAND_MAX);
	for(int i=0; i<10; i++){
		// random inputs (theta_in should be in range -PI~PI)
//		data_t theta_in = (data_t)(RAND * PI/180);
		data_t theta_in = test_angles[i];
		data_t sin_out, cos_out;
		data_t sin_ref, cos_ref;

		// reference results from standard library
		sin_ref = (data_t)sin((float)theta_in);
		cos_ref = (data_t)cos((float)theta_in);

		// output result from our implementation
		cordic_sin_cos(1, 0, theta_in, sin_out, cos_out);

		// check the correctness of your sine and cosine
		// if the error is larger than threshold, raise error
		if(abs((float)(sin_ref - sin_out)) > 0.01 || abs((float)(cos_ref - cos_out)) > 0.01){
			cout<<"Theta x(in radius): "<<theta_in<<endl;
			cout<<"Reference sin(x): "<<sin_ref<<endl;
			cout<<"Your sin(x): "<<sin_out<<endl;
			cout<<"Reference cos(x): "<<cos_ref<<endl;
			cout<<"Your cos(x): "<<cos_out<<endl;
			cout<<"[Error] Your implementation of sine or cosine is incorrect!"<<endl;
			return(-1);
		}
		cout << endl;
		cout << "theta_in = " << theta_in << endl;
		cout << "cos_ref = " << cos_ref << endl;
		cout << "cos_out = " << cos_out << endl;
		cout << "sin_ref = " << sin_ref << endl;
		cout << "sin_out = " << sin_out << endl;

	}
	cout << endl;
	cout << "[Success] Your implementation of sine and cosine are correct!" << endl;
	return(0);
}

int test_atan(void){
	// This part is to check the correctness of your arctan implementation
	// In this part, we provide 10 testcases for you to test your correctness
	// Note that the angle should be in range [-PI/2, PI/2]!!
	// You can first comment out this part if you haven't started this one

	// test angles (in degree): 89, 75, 60, 40, 15, -20, -30, -55, -70, -88
	data_t test_angles[10] = {1.5533430343, 1.308996939, 1.0471975512, 
							  0.6981317008, 0.261799388, -0.34906585,
							  -0.523598776, -0.95993109, -1.221730476,
							  -1.53588974};

	data_t sin_in, cos_in, atan_out, atan_ref;

	// Iterate thru testcases
	for(int i=0; i<10; i++){
		sin_in = (data_t) sin((float)test_angles[i]);
		cos_in = (data_t) cos((float)test_angles[i]);

		// your implemetation
		cordic_arctan(sin_in, cos_in, atan_out);
		// reference output
		atan_ref = (data_t) atan((float)(sin_in/cos_in));

		// check if the error is larger than threshold
		if(abs((float)(atan_ref - atan_out)) > 0.01){
			cout<<"Input sine: "<<sin_in<<endl;
			cout<<"Input cosine: "<<cos_in<<endl;
			cout<<"Reference arctan(x): "<<atan_ref<<endl;
			cout<<"Your arctan(x): "<<atan_out<<endl;
			cout<<"[Error] Your implementation of arctan should be wrong!"<<endl;
			return(-1);
		}
	}
	cout<<"[Success] Your implementation of arctan is correct!"<<endl;
	return(0);
}

// NOTE: You are allowed to modify the main function.
// It is strongly recommended that only one function is tested.
// Also, please use the provided test functions as above.
int main(){
	int correctness = 0;

	// correctness = test_sin_cos();
	correctness = test_atan();

	return(0);
}
