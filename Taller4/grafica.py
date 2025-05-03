import numpy as np
import matplotlib.pyplot as plt
import csv
import os

# Crear el vector de tiempo
t = np.arange(0, 0.201, 0.001)  # desde 0 hasta 0.20 con paso de 1 ms

# Definir la función por tramos
def u_piecewise(t):
    if t < 0.05:
        return 5
    elif t < 0.10:
        return 5 - 50*(t - 0.05)
    elif t < 0.15:
        return 0 + 60*(t - 0.15)
    else:
        return 6

# Calcular los valores de u(t)
u = np.array([u_piecewise(ti) for ti in t])

# Guardar en un archivo CSV con encabezados
ruta = os.path.expanduser("C:/Users/dario/Downloads/senal_piecewise.csv")
with open(ruta, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['Tiempo', 'u(t)'])
    writer.writerows(zip(t, u))

# Graficar la señal
plt.plot(t, u, 'b-', linewidth=2)
plt.xlabel('Tiempo (s)')
plt.ylabel('u(t)')
plt.title('Señal definida por tramos')
plt.grid(True)
plt.show()
