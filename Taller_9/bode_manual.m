% Parámetros del circuito
R = 100;
L = 112.54e-3;
C = 22.5e-6;

% Función de transferencia G(s) = num / den
num = 1/(L*C);
den = [1 R/L 1/(L*C)];

% Vector de frecuencias (rad/s)
N = 100;
w = logspace(-1, 8, N); % de 10^-1 a 10^7 rad/s

% Evaluar G(jw) para cada frecuencia
s = 1j * w; % j*omega   
Gjw = num ./ (s.^2 + den(2)*s + den(3));

% Magnitud en dB
mag_dB = 20*log10(abs(Gjw));

% Fase en radianes
phase = angle(Gjw)*(180/pi);

[GM, PM, Wcg, Wcp] = margin(tf(num, den));
fprintf('Margen de ganancia: %.2f dB\n', 20*log10(GM));
fprintf('Margen de fase: %.2f grados\n', PM);


% Graficar
figure(1);
subplot(2,1,1);
semilogx(w./(2*pi), mag_dB, 'LineWidth', 2);
grid on;
xlabel('Hz');
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud');

subplot(2,1,2);
semilogx(w./(2*pi), phase, 'LineWidth', 2);
grid on;
xlabel('Hz');
ylabel('Magnitud de fase');
title('Diagrama de Bode - Fase');

figure(2);
bode(tf(num,den));
