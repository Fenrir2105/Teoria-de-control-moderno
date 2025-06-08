import numpy as np
import matplotlib.pyplot as plt
from control import tf, series, feedback, rlocus
from sympy import symbols, Poly, diff, simplify

# Definir funciones de transferencia
num = [1]
den = [1, 4, 16]
G_1 = tf(num, den)

G_2 = tf([1, 3], [1, 1])
G_3 = tf([1], [1, 0])

G_4 = series(G_1, G_2)
G_5 = series(G_4, G_3)

H = 1
G_t = feedback(G_5, H)

# Polos y ceros de la función en lazo abierto
nume = G_5.num[0][0]
deno = G_5.den[0][0]

zs = np.roots(nume)
ps = np.roots(deno)

# Asíntotas
asintotas = len(ps) - len(zs)
ang_asin = 180 / asintotas
sal_asin = (np.sum(ps) - np.sum(zs)) / asintotas

# Líneas de las asíntotas
x = np.arange(sal_asin, 6, 0.1)
y1 = np.sqrt(3) * (x - sal_asin)
y2 = -y1
xa = np.arange(-6, sal_asin, 0.1)
ya = np.zeros_like(xa)

# Función de transferencia de K = -1 / (G_5 * H)
K = -1 / G_5

# Puntos de llegada (derivada de K(s))
s = symbols('s')
K_num_sym = Poly(K.num[0][0], s).as_expr()
K_den_sym = Poly(K.den[0][0], s).as_expr()
K_sym = simplify(K_num_sym / K_den_sym)

dK_ds = diff(K_sym, s)
num_expr, den_expr = dK_ds.as_numer_denom()
d_num_poly = Poly(num_expr, s)
coef_num = [float(c) for c in d_num_poly.all_coeffs()]
puntos = np.roots(coef_num)
p_real = puntos[np.isreal(puntos)].real

# Graficar
plt.figure()
plt.axis('square')
plt.axis([-6, 6, -6, 6])
plt.grid(True)

# Polos y ceros
plt.plot(np.real(zs), np.imag(zs), 'bo', linewidth=2, label='Ceros')
plt.plot(np.real(ps), np.imag(ps), 'rx', linewidth=2, label='Polos')

# Centroide de las asíntotas
plt.plot(np.real(sal_asin), 0, 'go', linewidth=2, label='Centroide')

# Puntos de llegada manuales (simulados del original)
plt.plot(0, 1.1547, 'ko', linewidth=2)
plt.plot(0, -1.1547, 'ko', linewidth=2)

if len(p_real) >= 2:
    plt.plot(p_real[0], 0, 'ko')
    plt.plot(p_real[1], 0, 'ko')

plt.plot(0, 3.1409, 'go')
plt.plot(0, -3.1409, 'go')

# Asíntotas
plt.plot(x, y1, 'k-.', label='Asíntotas')
plt.plot(x, y2, 'k-.')
plt.plot(xa, ya, 'k-.')

# Lugar de raíces
rlocus(G_t)

plt.title("Lazo abierto")
plt.legend()
plt.xlim([-6, 6])
plt.ylim([-6, 6])
plt.show()
