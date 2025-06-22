clear; clc;

R1 = 10e3;
R2 = 10e3;
R3 = 10e3;
R4 = 10e3;
C = 1e-6;
C1 = 1e-12;

num = R4*R2*[R1*C1 1];

den = R3*R1*[R2*C 1];

G_s = tf(num,den);

N = 1000;
w = logspace(-1, 10, N);

s1 = 1j*w;
P = (num(1)*s1 + num(2))./(den(1)*s1 + den(2));

mag_dB = 20*log10(abs(P));

phase = angle(P)*(180/pi);

[GM, PM, Wcg, Wcp] = margin(G_s);
fprintf('Margen de ganancia: %.2f dB\n', 20*log10(GM));
fprintf('Margen de fase: %.2f grados\n', PM);


    
figure(1);
subplot(2,1,1);
semilogx(w./(2*pi), mag_dB, 'LineWidth', 1);
grid on;
xlabel('Hz');
ylabel('Magnitud (dB)');
title('Diagrama de Bode - Magnitud');

subplot(2,1,2);
semilogx(w./(2*pi), phase, 'LineWidth', 1);
grid on;
xlabel('Hz');
ylabel('Magnitud de fase');
title('Diagrama de Bode - Fase');

figure(2);
bode(G_s)