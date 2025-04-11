import numpy as np
import matplotlib.pyplot as plt
import control as ctrl
from control import forced_response  # Importar la función similar a lsim

# Parámetros del sistema
num = [3]
den = [1, 2, 3]
theta = 2       # Retardo puro
ts = 0.1        # Tiempo de muestreo

# Sistema sin retardo
Gsr = ctrl.tf(num, den)

# Aproximación del retardo
num_pade, den_pade = ctrl.pade(theta, 1)
delay_sys = ctrl.tf(num_pade, den_pade)

# Sistema total con retardo
Gsr_with_delay = ctrl.series(delay_sys, Gsr)

# Vector de tiempo
t = np.arange(0, 30 + ts, ts)
N = len(t)

# Construcción de la señal arbitraria
sizev = int(N * 0.2)
s1 = np.ones(sizev) * 2
s2 = np.zeros(sizev)
s3 = np.linspace(5, 2, sizev)
s4 = np.linspace(3, 7, sizev)
s5 = np.ones(sizev + 1) * 7
arbsig = np.concatenate([s1, s2, s3, s4, s5])

# Asegurar que la señal tenga la misma longitud que el tiempo
if len(arbsig) < len(t):
    arbsig = np.append(arbsig, [arbsig[-1]] * (len(t) - len(arbsig)))
elif len(arbsig) > len(t):
    arbsig = arbsig[:len(t)]

# Simulación de la respuesta del sistema
t_out, y_out = forced_response(Gsr_with_delay, T=t, U=arbsig)

# Gráficas
plt.figure(figsize=(10, 6))

plt.subplot(2, 1, 1)
plt.plot(t, arbsig)
plt.title("Señal arbitraria")
plt.xlabel("Tiempo [s]")
plt.ylabel("Amplitud")
plt.grid(True)
plt.legend(["Señal en el tiempo"], loc="best")

plt.subplot(2, 1, 2)
plt.plot(t_out, y_out)
plt.plot(t, arbsig)
plt.title("Respuesta a la señal")
plt.xlabel("Tiempo [s]")
plt.ylabel("Amplitud")
plt.grid(True)
plt.legend(["Respuesta del sistema", "Arbitraria"], loc="best")
plt.tight_layout()
plt.show()
