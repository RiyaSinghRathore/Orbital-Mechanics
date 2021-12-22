# Plot 𝐸 = 1 − 𝑐𝑜𝑠(𝑥) + 0.5𝑦^2. Also find the contour plot for E = 1, 2, 3.

import matplotlib.pyplot as plt
import numpy as np


def f(x, y):
    return 1 - np.cos(X) + 0.5 * Y ** 2


x = np.linspace(-10, 10, 100)
y = np.linspace(-5, 5, 100)
X, Y = np.meshgrid(x, y)
Z = f(x, y)
fig, (ax, ax1) = plt.subplots(1, 2, figsize=(15, 10))
ax.contourf(X, Y, Z)
ax1.contour(X, Y, Z)
fig.suptitle('Plot of Z(x,y)')

# contour plot for Z = 1
fig, (ax, ax1) = plt.subplots(1, 2, figsize=(15, 10))
Z = 1 - np.cos(X) + 0.5 * Y ** 2
ax.contourf(X, Y, Z, 1)
ax1.contour(X, Y, Z, 1)
fig.suptitle('Contour Plot of Z = 1')

# contour plot for Z = 2
fig, (ax, ax1) = plt.subplots(1, 2, figsize=(15, 10))
Z = 1 - np.cos(X) + 0.5 * Y ** 2
ax.contourf(X, Y, Z, 2)
ax1.contour(X, Y, Z, 2)
fig.suptitle('Contour Plot of Z = 2')

# contour plot for Z = 3
fig, (ax, ax1) = plt.subplots(1, 2, figsize=(15, 10))
Z = 1 - np.cos(X) + 0.5 * Y ** 2
ax.contourf(X, Y, Z, 3)
ax1.contour(X, Y, Z, 3)
fig.suptitle('Contour Plot of Z = 3')
plt.show()
