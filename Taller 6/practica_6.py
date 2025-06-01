import numpy as np
import matplotlib.pyplot as plt
from control import tf, step_response, pzmap, feedback, series, parallel

# Parámetros del controlador PID
proporcional = 100
integral = 173141
derivativo = 0.0068

# Planta G_1(s) = 10^7 / (s^2 + 1000s + 10^7)
G_1 = tf([1e7], [1, 1000, 1e7])

# Componentes del PID
G_2 = tf([proporcional], [1])                 # Proporcional
G_3 = tf([integral], [1, 0])                  # Integral
G_4 = tf([derivativo, 0], [1])                # Derivativo

# PID total en paralelo
G_s_1 = parallel(G_2, G_3)
G_s_2 = parallel(G_s_1, G_4)

# PID + Planta en serie
G_s_3 = series(G_s_2, G_1)

# Realimentación unitaria
G_s_t = feedback(G_s_3, 1)

# Crear la figura con dos subplots
fig, axs = plt.subplots(2, 1, figsize=(8, 8))

# Subplot 1: respuesta al escalón
t, y = step_response(G_s_t)
axs[0].plot(t, y)
axs[0].set_title("Respuesta al Escalón del Sistema con Control PID")
axs[0].set_xlabel("Tiempo [s]")
axs[0].set_ylabel("Salida")
axs[0].grid(True)

# Subplot 2: mapa de polos y ceros
# pzmap devuelve polos y ceros, pero también podemos graficar directamente
pzmap(G_s_t, plot=True, ax=axs[1])
axs[1].set_title("Mapa de Polos y Ceros del Sistema en Lazo Cerrado")
axs[1].grid(True)

# Mostrar los gráficos
plt.tight_layout()
plt.show()
