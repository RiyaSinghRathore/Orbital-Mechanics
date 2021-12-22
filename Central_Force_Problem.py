# To obtain the solution of coupled ordinary differential equations obtained from F(r) = 1 (in polar coordinates)

from scipy.integrate import odeint
import numpy as np
import matplotlib.pyplot as plt


# Define Mass
m = 1


# Assign each ODE to a vector element
def odes(x):
    global m
    r = x[0]
    theta = x[1]
    r_dot = x[2]
    theta_dot = x[3]

    # Define each ODE
    derivative_r = r_dot
    derivative_theta = theta_dot
    derivative_r_dot = r * theta_dot ** 2 + 1 / m
    derivative_theta_dot = -2 * r_dot * theta_dot / r
    return [derivative_r, derivative_theta, derivative_r_dot, derivative_theta_dot]


# initial conditions
x0 = [5, 100, 1, 2]

# declare a time vector (time window)
t = np.linspace(0, 15, 1000)
x = odeint(odes, x0, t)
r = x[:, 0]
theta = x[:, 1]
r_dot = x[:, 2]
theta_dot = x[:, 3]

# Plot
figure, axis = plt.subplots(2, 2)
# For Eq 1
axis[0, 0].plot(t, r)
axis[0, 0].set_title("Equation 1: $dr/dt=U$")

# For Eq 2
axis[0, 1].plot(t, theta)
axis[0, 1].set_title("Equation 2: $d(theta)/dt=W$")

# For Eq 3
axis[1, 0].plot(t, r_dot)
axis[1, 0].set_title("Equation 3: $dr^2/dt^2=rW^2 + 1/m$")

# For Eq 4
axis[1, 1].plot(t, theta_dot)
axis[1, 1].set_title("Equation 4: $d^2(theta)/dt^2=-2UW/r$")

plt.show()
