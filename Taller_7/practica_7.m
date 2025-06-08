num = 1;
den = [1 4 16];

G_1 = tf(num,den);

G_2 = tf([1 3],[1 1]);

G_3 = tf(1,[1 0]);

G_4 = series(G_1,G_2);
G_5 = series(G_4,G_3);

H = 1;

G_t = feedback(G_5,1);

nume = G_5.num{1};
deno = G_5.den{1};

% Polos y ceros
zs = roots (nume);
ps = roots (deno);
%Asintotas
asintotas = length(ps) - length (zs);
ang_asin = 180/asintotas;
sal_asin = (sum(ps)-sum(zs))/asintotas;
% graficamos las líneas de las asíntotas
x = sal_asin:0.1:6;
y1 = sqrt (3) * (x - sal_asin);
y2 = -y1;
xa = -6:0.1:sal_asin;
ya = zeros(1, length(xa));

%Funcion de transferencia de K
K = -1/(G_5*H);
%puntos de llegada
syms s;
K_sym = poly2sym(K.num{1}, s)/poly2sym(K.den{1}, s)
[d_num,d_den] = numden(diff(K_sym, s));
puntos = roots(sym2poly(d_num));
p_real = puntos(imag(puntos) == 0);


% Graficar los polos y ceros
figure
v = [-6 6 -6 6]; axis (v); axis('square')
hold on; grid on;
plot(real(zs), imag(zs),'bo','Linewidth',2);
plot(real(ps), imag(ps),'rx','Linewidth',2);
plot(real(sal_asin), imag(sal_asin),'go','Linewidth',2);
plot(0, 1.1547,'ko','Linewidth',2);
plot(0, -1.1547,'ko','Linewidth',2);
plot(p_real(1),0,'ko');
plot(p_real(2),0,'ko');
plot(0,3.1409,'go');
plot(0,-3.1409,'go');
plot (x, y1, 'k-.');
plot (x, y2, 'k-.');
plot (xa, ya, 'k-.');
rlocus(G_t);
xlim([-6,6]);
ylim([-6,6]);
title("Lazo abierto")
