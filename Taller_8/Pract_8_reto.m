clear; clc;

syms s;
R = 22;
L = 500*10^(-6);
C = 220*10^(-6);

Mp = 0.25;
ts = 5e-3;

num = 1/(L*C);

den = [1 R/L 1/(L*C)];

G_s = tf(num, den);

zeta = log(1/Mp) / sqrt(pi^2 + (log(1/Mp))^2);
Wn = 4 / (ts * zeta);

poly = sym2poly(s^2 + 2*zeta*Wn*s + Wn^2);
raices = roots(poly);

r = roots(den);

P1 = r(1);
P2 = r(2);

theta1 = 180 + atand((imag(raices(1)-imag(P2)))/(real(raices(1))-real(P2)));
theta4 = 180 - theta1;
x = real(raices(1)) -(imag(raices(1))/tand(theta4));

comp = -0.8000 - 1j*1.8129;
num1 = (comp + abs(P1)) / (comp + abs(x));
num2 = 1/(L*C) / (comp^2 + (R/L)*comp + 1/(L*C));
gain = 1;

G = num1 * num2 * gain;

Kc = 1/abs(G);

G_c = Kc*tf([1 abs(P1)],[1 abs(x)]);

G_s_t = series(G_s,G_c);

G_S = feedback(G_s_t,1);

figure(1);
subplot(2,1,1);
step(G_s);
hold on;
step(G_S);
subplot(2,1,2);
rlocus(G_S);
hold on;
plot(real(raices(1)),imag(raices(1)),'rx');
hold on;
plot(real(raices(2)),imag(raices(2)),'rx');

figure(2);
subplot(3,1,1);
rlocus(G_s);
hold on;
plot(real(raices(1)),imag(raices(1)),'gx');
hold on;
plot(real(raices(2)),imag(raices(2)),'gx');
subplot(3,1,2);
pzmap(G_s_t);
hold on;
plot(real(raices(1)),imag(raices(1)),'gx');
hold on;
plot(real(raices(2)),imag(raices(2)),'gx');
subplot(3,1,3);
rlocus(G_s_t);
hold on;
plot(real(raices(1)),imag(raices(1)),'go');
hold on;
plot(real(raices(2)),imag(raices(2)),'go');

figure(3);
step(G_S);
