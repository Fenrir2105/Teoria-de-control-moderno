% Parámetros del circuito
R = 100; % Resistencia (ohmios)
L = 0.1; % Inductancia (henrios)
Cap = 1e-6; % Capacitancia (faradios)
A = [0 1; -1/(L*Cap) -R/L]; % Matriz de Estado
B = [0; 1/L]; % Matriz de Entrada
C = [1/Cap 0]; % Matriz de Salida
D = 0; % Matriz de Transferencia directa

sys = ss(A,B,C,D);
subplot(2,1,1);
step(sys);
xlabel('Time [s]'); ylabel('Vc [V]');
subplot(2,1,2);
impulse(sys);
xlabel('Time [s]'); ylabel('Vc [V]');

ts = 0.015; % Tiempo de simulación
tspan = [0 ts];
u = 1; % Voltaje de entrada
x0 = [0; 0]; % Condiciones iniciales
[t, X] = ode45(@(t,x) modelRLC(t, x, A, B, u), tspan, x0);
y = C * X.' + D * u;

% Aquí el código para definir el espacio de estados
function dx = modelRLC(t, x, A, B, u)
dx = A * x + B * u; % Ecuación de Estado
end

