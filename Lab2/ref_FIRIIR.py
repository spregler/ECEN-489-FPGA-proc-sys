################################################################################
## ECEN489/689 Lab2 Spring 2022.
## This script helps you calculalte the outputs of the FIR/IIR filters.
################################################################################

## FIR
print("\nReferece for FIR:")
a = 0.5
b = -1.5
c = 2.0
x = [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5]

## x[n], x[n-1], x[n-2]
x_n0 = 0
x_n1 = 0
x_n2 = 0


for i in range(len(x)):
	x_n2 = x_n1
	x_n1 = x_n0
	x_n0 = x[i]
	y = a*x_n0 + b*x_n1 + c*x_n2
	print("y[" + str(i) + "] = ", y)


## IIR
print("\nReference for IIR:")

d = -1.0

## x[n], x[n-1], y[n], y[n-1], y[n-2].
x_n0 = 0
x_n1 = 0
y_n0 = 0
y_n1 = 0
y_n2 = 0

## y_Q34 is the fixed point representation of y[n].
y_Q34 = 0

for i in range(len(x)):
	x_n1 = x_n0
	x_n0 = x[i]
	y_n2 = y_n1
	y_n1 = y_n0
	y_n0 = a*x_n0 + b*x_n1 + c*y_n1	+ d*y_n2
	y_Q34 = y_n0

	## What is the purpose of this while-loop?
	## Hint: Overflow of Q(3,4) representation.
	while(y_Q34 >= 8 ):
		y_Q34 -= 16

	while(y_Q34 < -8):
		y_Q34 += 16
	
	print("y[" + str(i) + "] = ", y_n0, "\ty_Q34[" + str(i) + "] = ", y_Q34)

