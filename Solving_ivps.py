# Write a program in the language of you choice for finding solution of 𝑑𝑦/𝑑𝑥 = 𝑥^2 + 𝑦 + 0.1𝑦^2 with initial
# condition y(0)=0. Find the value at 2.0 upto fourdecimal places.
import numpy as np
import matplotlib.pyplot as plt
from scipy.integrate import solve_ivp


def eq(x, y):
    return (x * x + y + 0.1 * y ** 2)


t_span = (0, 2)

# Creating vectors
x = np.linspace(0, 2, 100)
y0 = np.array([0])
sol = solve_ivp(eq, t_span, y0, t_eval=x)

# print(sol)
Y = sol.y[0]
X = sol.t
plt.figure(figsize=(10, 5))
plt.plot(X, Y)
plt.xlabel('x-axis')
plt.ylabel('y-axis')
plt.show()

# value at 2.0 upto four decimal places
print("Solution of Y(2.0)= {0:.4f}".format(Y[99]))
