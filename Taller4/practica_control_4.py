import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
from control import ss, step_response, impulse_response
from scipy.integrate import solve_ivp
from scipy.interpolate import interp1d

# Parámetros del circuito
R = 100           # Ohmios
L = 0.1           # Henrios
Cap = 1e-6        # Faradios

# Matrices del sistema
A = np.array([[0, 1], [-1/(L*Cap), -R/L]])
B = np.array([[0], [1/L]])
C = np.array([[1/Cap, 0]])
D = np.array([[0]])

# Crear sistema
sys = ss(A, B, C, D)

# Tiempo para las respuestas al escalón y al impulso (hasta 0.15s)
t1 = np.linspace(0, 0.15, 2000)

# Respuesta al escalón
t_step, y_step = step_response(sys, T=t1)

# Respuesta al impulso
t_impulse, y_impulse = impulse_response(sys, T=t1)

# Leer la señal desde el CSV
data = pd.read_csv("C:/Users/dario/Downloads/senal_piecewise.csv")
t_csv = data['t'].values
u_csv = data['u'].values
u_func = interp1d(t_csv, u_csv, fill_value="extrapolate")

# Dinámica del sistema con entrada arbitraria
def rlc_system(t, x):
    u = u_func(t)
    dx = A @ x + B.flatten() * u
    return dx

# Resolver la dinámica con entrada arbitraria
x0 = [0, 0]
t_eval = np.linspace(t_csv[0], t_csv[-1], 2000)
sol = solve_ivp(rlc_system, (t_csv[0], t_csv[-1]), x0, t_eval=t_eval)
y_custom = C @ sol.y + D * u_func(sol.t)

# Graficar las tres respuestas en un subplot
plt.figure(figsize=(12, 10))

# Subplot 1: Respuesta al escalón
plt.subplot(3, 1, 1)
plt.plot(t_step, y_step.flatten(), 'b-', label='Respuesta al escalón')
plt.title('Respuesta al Escalón')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc(t) [V]')
plt.grid(True)

# Subplot 2: Respuesta al impulso
plt.subplot(3, 1, 2)
plt.plot(t_impulse, y_impulse.flatten(), 'g-', label='Respuesta al impulso')
plt.title('Respuesta al Impulso')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc(t) [V]')
plt.grid(True)

# Subplot 3: Respuesta a la señal arbitraria
plt.subplot(3, 1, 3)
plt.plot(sol.t, y_custom.flatten(), 'r-', label='Respuesta a señal arbitraria')
plt.title('Respuesta a la Señal Arbitraria')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc(t) [V]')
plt.grid(True)

# Ajustar el layout y mostrar
plt.tight_layout()
plt.show()
