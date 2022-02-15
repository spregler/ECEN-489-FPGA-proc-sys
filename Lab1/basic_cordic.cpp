/*********************************************************************/
// Description:														  /
//     Your C++ implementation of CORDIC.                             /
//	   Please follow the instructions below to complete the function. /
/*********************************************************************/

#include"basic_cordic.h"
#include <iostream>

using namespace std;

void cordic_sin_cos(data_t x0, data_t y0, data_t z0, data_t &sin_out, data_t &cos_out){
/*
This function is the core part of calculating sin and cos using CORDIC.
Please complete this function to calculate the result of sin(z0) and cos(z0)!

Input:
	x0, y0: initial values for the CORDIC process
	z0	  : input angle for your sin or cos output (should be in range [-PI, PI])
Output: (Note that in HLS, we don't use "return" as this is not supported by HLS)
	sin_out: output result of sin(z0)
	cos_out: output result of cos(z0)

Hint:
	Step 1: Set the proper value for x0, y0, z0
	Step 2: Map the original theta to the valid working range of CORDIC (-PI/2~PI/2).
			sin(PI-theta) = sin(PI)cos(theta) - cos(PI)sin(theta) = sin(theta)
			cos(PI-theta) = cos(PI)cos(theta) + sin(PI)sin(theta) = -cos(theta)
	Step 3: Use the equation in to iteratively update xk, yk, zk
	Step 4: After the iteration is done, make sure zk is zero
	Step 5: Select the proper result for sin(z0) and cos(z0)
*/

	/*************** Example code here ***************/
	// 1)
	data_t xi[N];
	data_t yi[N];
	data_t zi[N];

	xi[0] = (data_t) 1/G * x0;
	yi[0] = (data_t) 1/G * y0;

	// 2)
	// determine zi[0]
	if(z0 > PI/2){
		// original theta is larger than 90 degree (PI/2)
		zi[0] = PI - z0;
	}
	else if(z0 < -PI/2){
		// original theta is smaller than -90 degree (-PI/2)
		zi[0] = -PI - z0;
	}
	else{
		// else don't need to change
		zi[0] = z0;
	}
	// 3)
	#pragma HLS pipeline II=1
	for(int m=0; m<N; m++){
		// 4)
		if(zi[m] >= 0){
			xi[m+1] = xi[m] - (yi[m] >> m);
			yi[m+1] = yi[m] + (xi[m] >> m);
			zi[m+1] = zi[m] - atan4cordic[m];
		}
		else{
			xi[m+1] = xi[m] + (yi[m] >> m);
			yi[m+1] = yi[m] - (xi[m] >> m);
			zi[m+1] = zi[m] + atan4cordic[m];
		}
	}

	// 5)
	// Select the proper result
	sin_out = yi[N-1];
	if(z0 > PI/2 || z0 < -PI/2){
		cos_out = -xi[N-1];
	}
	else{
		cos_out = xi[N-1];
	}
	/********************* Done *********************/
}

void cordic_arctan(data_t sin_in, data_t cos_in, data_t &atan_out){
/*
This function is the core part of calculating arctan using CORDIC.
Please complete this function to calculate the result of arctan(sin_in/cos_in)!

Input:
	sin_in: sine value (should be in range [-1, 1])
	cos_in: cosine value (should be in range [0, 1])
Output: (Note that in HLS, we don't use "return" as this is not supported by HLS)
	atan_out: output angle of atan(sin_in/cos_in) (should be in range [-PI/2, PI/2])

Hint:
	Step 1: Set the proper value for x0, y0, z0
	Step 2: Use the equation in to iteratively update xk, yk, zk
	Step 3: After the iteration is done, make sure zk is zero
	Step 4: Select the proper result for atan(sin_in/cos_in)
*/

	/*************** Your code here ***************/
	// 1)
	data_t xi[N];
	data_t yi[N];
	data_t zi[N];

	xi[0] = cos_in;
	yi[0] = sin_in;
	zi[0] = 0;

	#pragma HLS pipeline II=1
	for(int m=0; m<N; m++){
		// 2)
		if(yi[m] >= 0){
			xi[m+1] = xi[m] + (yi[m] >> m);
			yi[m+1] = yi[m] - (xi[m] >> m);
			zi[m+1] = zi[m] + atan4cordic[m];
		}
		else{
			xi[m+1] = xi[m] - (yi[m] >> m);
			yi[m+1] = yi[m] + (xi[m] >> m);
			zi[m+1] = zi[m] - atan4cordic[m];
		}
	}

	atan_out = zi[N];
	/********************* Done *********************/
}
