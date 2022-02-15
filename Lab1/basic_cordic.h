	/*******************************************************************/
// Description:														/
//		Header file for cordic module. Please do not modify this 	/
//		code. 														/
/*******************************************************************/

#include <ap_fixed.h>
#include <ap_int.h>

// use 16-bit fixed point values with 12 bits for fraction
#define bitwidth 16
#define fraction_bits 12
typedef ap_fixed<bitwidth, bitwidth-fraction_bits> data_t;

// define the constant values and convert to fixed point values
const data_t G = 1.64676;
const data_t PI = 3.1415926;
const int N = 15;


// A look up table for atan(2^(-0)), atan(2^(-1)), ..., atan(2^(-14)).
const data_t atan4cordic[15] = {
	0.7853981, 0.4636476, 0.2449787, 0.1243549, 0.0624188,
	0.0312398, 0.0156237, 0.0078123, 0.0039062, 0.0019531,
	0.0009765, 0.0004883, 0.0002441, 0.0001221, 0.0000610
};

// function declaration
void cordic_sin_cos(data_t x0, data_t y0, data_t z0, data_t &sin_out, data_t &cos_out);
void cordic_arctan(data_t sin_in, data_t cos_in, data_t &atan_out);
