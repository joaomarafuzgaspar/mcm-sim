%function [x, y, phi, r] = kinematics_model(n) 
n = 1000;

t = linspace(0, 10, n + 1);
u = rand(1, n);

r = zeros(1, n);
r(1) = -0.1;
phi = zeros(1, n);
phi(1) = pi / 4;
x = zeros(1, n);
x(1) = 500;
y = zeros(1, n);
y(1) = 500;

% USV Kinematic Model (Nomoto)
V = 2.5; % [m/s]
T = 5.0; % [s]
K = 0.5; % [1/s]

for i = 2:n
    delta_t = t(i) - t(i - 1);
    r(i) = r(i - 1) + 1 / T * (K * u(i) - r(i)) * delta_t;
    phi(i) = phi(i - 1) + r(i) * delta_t;
    x(i) = x(i - 1) + V * cos(phi(i));
    y(i) = y(i - 1) + V * sin(phi(i));
end

x = x / 100;
y = y / 100;

% Code for displaying direction (orange)
direction_length = 1.5;
x_direction = x + direction_length * cos(phi);
y_direction = y + direction_length * sin(phi);
X_direction = [x', x_direction'];
Y_direction = [y', y_direction'];

% Code for displaying sensor range (yellow)
% range_length = 2;
% range_angle = pi/3;
% x_range_right = x + range_length * cos(phi - range_angle / 2);
% y_range_right = y + range_length * sin(phi - range_angle / 2);
% X_range_right = [x', x_range_right'];
% Y_range_right = [y', y_range_right'];
% x_range_left = x + range_length * cos(phi + range_angle / 2);
% y_range_left = y + range_length * sin(phi + range_angle / 2);
% X_range_left = [x', x_range_left'];
% Y_range_left = [y', y_range_left'];

f1 = figure(1);
f1.Position = f1.Position + [-300 -250 0 0];
target_probability = target_location(3000);

f2 = figure(2);
f2.Position = f2.Position + [300 -250 0 0];
for i = 1:n
    f2 = figure(2);
    plot(x(1:i), y(1:i), "LineWidth", 2);
    hold on
    plot(x(i), y(i), '.', 'MarkerSize', 20);
    %plot(X_range_right(i, :), Y_range_right(i, :), "LineWidth", 1.5, "Color", [0.9290 0.6940 0.1250]);
    %plot(X_range_left(i, :), Y_range_left(i, :), "LineWidth", 1.5, "Color", [0.9290 0.6940 0.1250]);
    plot(X_direction(i, :), Y_direction(i, :), "LineWidth", 1.5, "Color", [0.8500 0.3250 0.0980]);
    hold off
    set(gca, "TickLabelInterpreter", "latex");
    set(gca, "fontsize", 14); 
    xlabel("Easting (DU)", "Interpreter", "latex", "fontsize", 18);
    ylabel("Northing (DU)", "Interpreter", "latex", "fontsize", 18);
    title("USV Path", "Interpreter", "latex", "fontsize", 18);
    xlim([0, 30])
    ylim([0, 30])
    grid on
    grid minor
    pause(.001)
end

%saveas(gca, "Path.png")
close all