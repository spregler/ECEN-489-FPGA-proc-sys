/*******************************************************************/
// Description:														/
//	   Header file for hyperbolic cordic module. 					/
//	   Please do not modify this code. 								/
/*******************************************************************/

#include <ap_fixed.h>
#include <ap_int.h>

// use 16-bit fixed point values with 13 bits for fraction
#define bitwidth 16
#define fraction_bits 12
typedef ap_fixed<bitwidth, bitwidth-fraction_bits> data_t;

// define the constant values and convert to fixed point values
const data_t A = 0.828159;
const data_t PI = 3.1415926;
const int N = 16;

const data_t atanh4cordic[16] = {
	0, 0.549306, 0.255413, 0.125657, 0.0625816, 0.0312602,
	0.0156263, 0.00781266, 0.00390627, 0.00195313, 0.000976562,
	0.000488281, 0.00024414, 0.00012207, 0.0000610351, 0.0000305176
};

// function declaration
void cordic_sinh_cosh(data_t x0, data_t y0, data_t z0, data_t &sinh_out, data_t &cosh_out);