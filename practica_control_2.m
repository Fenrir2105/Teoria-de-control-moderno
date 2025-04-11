clc; clear;

num = 3;
den = [1 2 3];
ts = 0.1;
theta = 2;
Gs = tf(num,den); %T. continuo
Gsr = tf(num,den,'InputDelay', theta);
[impulso, t1] = impulse(Gs);
[escalon,t2] = step(Gs);
[impulso_ret,t3] = impulse(Gsr);
[escalon_ret,t4] = step(Gsr);
max_imp = max(impulso);
max_esc = max(escalon);
max_imp_ret = max(impulso_ret);
max_esc_ret = max(escalon_ret);

[~, id_imp] = min(abs(impulso - max_imp));
t_aprox_imp = t1(id_imp);
[~, id_esc] = min(abs(escalon - max_esc));
t_aprox_esc = t2(id_esc);
[~, id_imp_ret] = min(abs(impulso_ret - max_imp_ret));
t_aprox_imp_ret = t3(id_imp_ret);
[~, id_esc_ret] = min(abs(escalon_ret - max_esc_ret));
t_aprox_esc_ret = t4(id_esc_ret);

% subplot(2,1,1);
% plot(t1,impulso);
% hold on;
% scatter(t_aprox_imp,max_imp);
% subplot(2,1,2);
% plot(t2, escalon);
% hold on;
% scatter(t_aprox_esc,max_esc);

% subplot(2,1,1);
% plot(t3,impulso_ret);
% hold on;
% scatter(t_aprox_imp_ret,max_imp_ret);
% subplot(2,1,2);
% plot(t4, escalon_ret);
% hold on;
% scatter(t_aprox_esc_ret,max_esc_ret);

t = 0:ts:30;
t = t';
N = length(t);

sizev = int32(N*0.2);

%senal arbitraria
s1 = ones(1, sizev)*2;
s2 = zeros(1,sizev);
s3 = linspace(5,2,sizev);
s4 = linspace(3,7,sizev);
s5 = ones(1,sizev + 1)*7;


arbsig = [s1,s2,s3,s4,s5]';
u2 = [t arbsig];

subplot(2,1,1);
plot(t,arbsig);
grid on;
title("Señal arbitraria");
xlabel("Tiempo");
ylabel("Amplitud");
legend("Señal en el tiempo", 'Location', 'best');
subplot(2,1,2);
lsim(Gsr,arbsig,t);
grid on;
title("Respuesta a la señal");
xlabel("Tiempo");
ylabel("Amplitud");
legend("Respuesta del sistema", 'Location', 'best');
