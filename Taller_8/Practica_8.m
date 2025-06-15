syms s;
Ra = 0.635;
La = 0.0883;
Ki = 9.43*10^(-3);
Kb = 1010;
Jm = 330;
Bm = 0.001;
Mp = 0.1;
ts = 1;

zeta = log(1/Mp)/sqrt(pi^2+log(1/Mp)^2);
Wn = 4/(ts*zeta);

num = Ki/(La*Jm);

den = [1 (Bm/Jm + Ra/La) ((Ra*Bm)+(Ki*Kb))/(La*Jm)];

G_s = tf(num,den);

poly = sym2poly(s^2 + 2*zeta*Wn*s + Wn^2);
raices = roots(poly);

r = roots(den);

P1 = r(1);
P2 = r(2);

theta1 = 180 + atand((imag(raices(1)-imag(P2)))/(real(raices(1))-real(P2)));
theta4 = 180 - theta1;
x = -4 -(imag(raices(1))/tand(theta4));

comp = -4 + 1j*5.4575;
num1 = (comp + 7.1457) / (comp + 7.9543);
num2 = 3.236e-4 / (comp^2 + 7.191*comp + 0.3269);
gain = 1010;

G = num1 * num2 * gain;

Kc = 1/abs(G);

G_c = Kc*tf([1 abs(P1)],[1 abs(x)]);

G_s_t = series(G_s,G_c);

G_S = feedback(G_s_t,Kb);
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
ylim([-8,8]);

figure(2);
subplot(3,1,1);
rlocus(G_s);
hold on;
plot(real(raices(1)),imag(raices(1)),'gx');
hold on;
plot(real(raices(2)),imag(raices(2)),'gx');
ylim([-6,6]);
subplot(3,1,2);
pzmap(G_s_t);
hold on;
plot(real(raices(1)),imag(raices(1)),'gx');
hold on;
plot(real(raices(2)),imag(raices(2)),'gx');
ylim([-6,6]);
subplot(3,1,3);
rlocus(G_s_t);
hold on;
plot(real(raices(1)),imag(raices(1)),'go');
hold on;
plot(real(raices(2)),imag(raices(2)),'go');
ylim([-6,6]);

figure(3);
step(G_S);