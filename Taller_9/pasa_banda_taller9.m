clc, close all, clear

% Parámetros del circuito
R = 100;
L = 159.15e-3;     % Inductancia en Henrios
C = 15.91e-6;       % Capacitancia en Faradios

num = [R/L 0];                     % L*C*s
den = [1  R/L  1/L*C];               % L*C*s^2 + R*C*s + 1

% Crear función de transferencia
G = tf(num, den);

% Vector de frecuencias logarítmicas
w = logspace(-10, 6, 1000); % 1 Hz a 1 MHz
s = 1j * w;

% Evaluación manual de G(jw)
Gjw = polyval(num, s) ./ polyval(den, s);
mag_dB = 20*log10(abs(Gjw));
phase = angle(Gjw) * (180/pi);
fc = bandwidth(G);
fprintf('Frecuencia de corte: %.2f Hz\n', fc);


% Graficar manualmente
figure;
subplot(2,1,1);
semilogx(w/(2*pi), mag_dB, 'b', 'LineWidth', 2);
grid on;
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud (Filtro Pasa Altos)');

subplot(2,1,2);
semilogx(w/(2*pi), phase, 'r', 'LineWidth', 2);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (°)');
title('Diagrama de Bode - Fase (Filtro Pasa Altos)');

figure;
margin(G);
title('Diagrama de Bode con márgenes (Filtro Pasa Altos)');
