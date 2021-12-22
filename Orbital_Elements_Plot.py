import numpy as np
import matplotlib.pyplot as plt

# Define Orbital Elements
T = 12  # in hours
e = 0.7
omega = 270 * np.pi / 180
longitude = 0 * np.pi / 180
inclination = 63.4 * np.pi / 180

# Calculate a and b
mu = 3.98618e14  # Earth's geocentric gravitational constant
a = (((T * 60 * 60) ** 2 * mu) / (4 * np.pi ** 2)) ** (1 / 3)  # semi-major axis
b = a * (1 - e ** 2) ** (1 / 2)  # semi-minor axis

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
theta = np.linspace(0, 2 * np.pi, 201)

# Plot Reference Circle
r = 2 * b + 0.5 * 10 ** 7
y = r * np.cos(theta)
x = r * np.sin(theta)
for i in range(1):
    phi = i * np.pi
    ax.plot(x, y * np.cos(phi) + r * np.cos(phi) - r, y * np.sin(phi) + r * np.sin(phi))

# Plot Orbit (Using cartesian form of the orbit equation)
y = 2 * b * np.cos(theta)
x = 2 * a * np.sin(theta)
for i in range(1):
    phi = i * np.pi
    # Rotation about z-axis (omega-argument of perigee)
    x1 = y * np.cos(omega) + x * np.sin(omega)
    y1 = (-x * np.cos(omega) + y * np.sin(omega)) * np.cos(phi) + 2 * b * np.cos(phi) - 2 * b
    z1 = (-x * np.cos(omega) + y * np.sin(omega)) * np.sin(phi) + a * np.sin(phi)
    # Rotation about x-axis (inclination)
    x2 = x1
    y2 = y1 * np.cos(longitude) + z1 * np.sin(longitude)
    z2 = z1 * np.cos(longitude) - y1 * np.sin(longitude)
    # Rotation about y-axis (Longitude of ascending node)
    x3 = x2 * np.cos(inclination) - z2 * np.sin(inclination)
    y3 = y2
    z3 = z2 * np.cos(inclination) + x2 * np.sin(inclination)
    ax.plot(x3 - a * e, y3, z3)

ax.set_title('Plotting Orbits from Orbital Elements')
ax.auto_scale_xyz([-2 * a - 1, 2 * a + 1], [-2 * a - 1, 2 * a + 1], [-2 * a - 1, 2 * a + 1])
plt.legend(["Reference", "Orbit"])
ax.set_xlabel('X-Axis')
ax.set_ylabel('Y-Axis')
ax.set_zlabel('Z-Axis')
plt.show()
