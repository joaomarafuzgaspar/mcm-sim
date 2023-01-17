clc
clear

% Generate waypoints for lawn-mower pattern path
waypoints = zeros(10, 2);
waypoints(:, 1) = [500 2500 2500 500 500 2500 2500 500 500 2500];
waypoints(:, 2) = [500 500 1000 1000 1500 1500 2000 2000 2500 2500];
[x, y, phi, r, t] = los_controller(waypoints);

% Code for displaying direction (orange)
direction_length = 1.5;
x_direction = x + direction_length * cos(phi);
y_direction = y + direction_length * sin(phi);
X_direction = [x', x_direction'];
Y_direction = [y', y_direction'];

% Code for displaying sensor range (yellow)
range_length = 2;
range_angle = pi/3;
x_range_right = x + range_length * cos(phi - range_angle / 2);
y_range_right = y + range_length * sin(phi - range_angle / 2);
X_range_right = [x', x_range_right'];
Y_range_right = [y', y_range_right'];
x_range_left = x + range_length * cos(phi + range_angle / 2);
y_range_left = y + range_length * sin(phi + range_angle / 2);
X_range_left = [x', x_range_left'];
Y_range_left = [y', y_range_left'];

f1 = figure(1);
f1.Position = f1.Position + [0 0 1000 0];
movegui(f1, "center");

% Target
mu = [10; 10];
sigma = 5;
Sigma = diag([sigma sigma]);
subplot(1, 3, 1)
p = target_location(x, y, mu, Sigma);

%% Plotter
% USV
subplot(1, 3, 2)
scatter(waypoints(:, 1)/100, waypoints(:, 2)/100, 100, [0.6350 0.0780 0.1840], "pentagram", "filled");
hold on

plot(x(1:4598), y(1:4598), "LineWidth", 2, "Color", "green")

x_p1 = x(1); y_p1 = y(1);
p1 = plot(x_p1, y_p1, "LineWidth", 2, "Color", [0 0.4470 0.7410]);
p1.XDataSource = 'x_p1'; p1.YDataSource = 'y_p1';

x_p2 = x(1); y_p2 = y(1);
p2 = plot(x_p2, y_p2, '.', 'MarkerSize', 20, "Color", [0.8500 0.3250 0.0980]);
p2.XDataSource = 'x_p2'; p2.YDataSource = 'y_p2';

x_p3 = X_range_right(1, :); y_p3 = Y_range_right(1, :);
p3 = plot(x_p3, y_p3, "LineWidth", 1.5, "Color", [0.9290 0.6940 0.1250]);
p3.XDataSource = 'x_p3'; p3.YDataSource = 'y_p3';

x_p4 = X_range_left(1, :); y_p4 = Y_range_left(1, :);
p4 = plot(x_p4, y_p4, "LineWidth", 1.5, "Color", [0.9290 0.6940 0.1250]);
p4.XDataSource = 'x_p4'; p4.YDataSource = 'y_p4';

x_p5 = X_direction(1, :); y_p5 = Y_direction(1, :);
p5 = plot(x_p5, y_p5, "LineWidth", 1.5, "Color", [0.8500 0.3250 0.0980]);
p5.XDataSource = 'x_p5'; p5.YDataSource = 'y_p5';
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

% Probability of detection
subplot(1, 3, 3)

t_p6 = t(1); p_p6 = p(1);
p6 = plot(t_p6, p_p6, "LineWidth", 2);
p6.XDataSource = 't_p6'; p6.YDataSource = 'p_p6';
hold on

t_p7 = t(1); p_p7 = p(1);
p7 = plot(t_p7, p_p7, '.', 'MarkerSize', 20);
p7.XDataSource = 't_p7'; p7.YDataSource = 'p_p7';
hold off

set(gca, "TickLabelInterpreter", "latex");
set(gca, "fontsize", 14); 
xlabel("$t$ [s]", "Interpreter", "latex", "fontsize", 18);
ylabel("$p(t)$", "Interpreter", "latex", "fontsize", 18);
title("Probability of detection", "Interpreter", "latex", "fontsize", 18);
grid on

for i = 1:length(x)
    x_p1(i) = x(i); y_p1(i) = y(i);
    x_p2 = x(i); y_p2 = y(i);
    x_p3 = X_range_right(i, :); y_p3 = Y_range_right(i, :);
    x_p4 = X_range_left(i, :); y_p4 = Y_range_left(i, :);
    x_p5 = X_direction(i, :); y_p5 = Y_direction(i, :);

    t_p6(i) = t(i); p_p6(i) = p(i);
    t_p7 = t(i); p_p7 = p(i);
    legend("", "$p(" + num2str(t(i)) + ") = " + num2str(p(i)) + "$", "Interpreter", "latex");
    xlim([0, 1 + max(t(1:i))])
    ylim([0, 1.2 * max(p(1:i))])

    refreshdata
    drawnow
    if i == 20
        break
    end
end

close all