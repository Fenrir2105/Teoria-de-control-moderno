proporcional = 100;
integral = 173141;
derivativo = 0.0068;

G_1 = tf(10000000, [1 1000 10000000]);

G_2 = proporcional;

G_3 = integral*tf(1, [1 0]);

G_4 = derivativo*tf([1 0],1);

H_1 = 1;

G_s_1 = parallel(G_2,G_3);
G_s_2 = parallel(G_s_1,G_4);

G_s_3 = series(G_s_2, G_1);

G_s_t = feedback(G_s_3,H_1);

subplot(2,1,1)
step(G_s_t)
subplot(2,1,2)
pzmap(G_s_t)


