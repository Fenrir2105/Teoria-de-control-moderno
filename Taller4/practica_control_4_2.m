% Parámetros del circuito
R = 100; % Ohmios
L = 0.1; % Henrios
Cap = 1e-6; % Faradios

% Matrices del sistema en espacio de estados
A = [0 1; -1/(L*Cap) -R/L];
B = [0; 1/L];
C = [1/Cap 0];
D = 0;

% Crear el sistema
sys = ss(A,B,C,D);

% Nueva duración de simulación
ts = 0.20;                        % Tiempo final
x0 = [0; 0];                      % Condiciones iniciales
tspan = linspace(0, ts, 5000);   % Más puntos para mejor resolución

% Simulación con entrada por tramos
[t, X] = ode45(@(t,x) modelRLC_piecewise(t, x, A, B), tspan, x0);

% Calcular salida
u_values = arrayfun(@u_piecewise, t);  % Evaluar entrada en cada t
y = (C * X.' + D * u_values.').';

% Graficar entrada y salida
figure;
subplot(2,1,1);
plot(t, u_values, 'r', 'LineWidth', 1.5);
xlabel('Tiempo [s]'); ylabel('u(t)');
title('Señal de entrada por tramos');
grid on;

subplot(2,1,2);
plot(t, y, 'b', 'LineWidth', 1.5);
xlabel('Tiempo [s]'); ylabel('Vc(t)');
title('Respuesta del sistema RLC');
grid on;

% Función de dinámica del sistema
function dx = modelRLC_piecewise(t, x, A, B)
    u = u_piecewise(t);         % Entrada por tramos
    dx = A * x + B * u;
end

% Señal de entrada definida por tramos sobre [0, 0.20] s
function u = u_piecewise(t)
    if t < 0.05
        u = 5;                            % constante
    elseif t < 0.10
        u = 5 - 50*(t - 0.05);           % rampa decreciente
    elseif t < 0.15
        u = 0 + 60*(t - 0.15);           % rampa creciente
    else
        u = 6;                            % constante final
    end
end
