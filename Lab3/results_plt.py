import matplotlib.pyplot as plt
import numpy as np

def output_graph(file):
    with open(file) as f:
        lines = f.readlines()

    return [float(x) for x in lines]

original = output_graph('original.txt')
filtered = output_graph('filtered.txt')

n = np.arange(300);
x = original
y = filtered
plt.xlabel('n');
plt.ylabel('x[n]');
plt.title("Unfolded IIR FPGA Implementation Test");
plt.plot(n, x, label='Original', color='indianred')
plt.plot(n, y, label='Filtered', color='r')
plt.legend()
