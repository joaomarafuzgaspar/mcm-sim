close all
clear
waypoints = zeros(10, 2);
waypoints(:, 1) = [2000 2500 2500 500 500 2500 2500 500 500 2500];
waypoints(:, 2) = [500 500 1000 1000 1500 1500 2000 2000 2500 2500];

% Initializations
n = 7200;
t = linspace(0, 7200, n);

x = zeros(1, n);
y = zeros(1, n);
phi = zeros(1, n);
r = zeros(1, n);

x(1) = waypoints(1, 1);
y(1) = waypoints(1, 2);
phi(1) = 0;
r(1) = 0;

alpha = zeros(1, n - 1);
e = zeros(1, n - 1);
delta = zeros(1, n - 1);
chi_r = zeros(1, n - 1);
int_e = zeros(1, n - 1);
chi_d = zeros(1, n - 1);

phi_d = zeros(1, n - 1);
phi_err = zeros(1, n - 1);
int_phi_err = zeros(1, n - 1);
u = zeros(1, n - 1);

Kp = 1;
Ki = 0.1;
Kp_los = zeros(1, n - 1);
Ki_los = 0;
R = 200;

% USV Kinematic Model (Nomoto)
V = 2.5; % [m/s]
T = 4.0; % [s]
K = 0.5; % [1/s]


%% Display
% Red dot: LOS points
% Green dot: AUV
% Greem circle: AUV treshold to change waypoint destination
% Red pentagrams: waypoints
% Blue line: AUV's path
fig = figure;

%plot(x, y, 'LineWidth', 2);
%hold on

x_p4 = x(1); y_p4 = y(1);
p4 = plot(x_p4, y_p4, 'LineWidth', 2);
p4.XDataSource = 'x_p4'; p4.YDataSource = 'y_p4';
hold on

scatter(waypoints(:, 1), waypoints(:, 2), 100, [0.6350 0.0780 0.1840], "pentagram", "filled");
hold on

[x_p2, y_p2] = circ(x(1), y(1), R);
p2 = plot(x_p2, y_p2, "Color", 'green', 'LineWidth', 2);
p2.XDataSource = 'x_p2'; p2.YDataSource = 'y_p2';

x_p3 = x(1); y_p3 = y(1);
p3 = plot(x_p3, y_p3, '.', 'MarkerSize', 20, "Color", 'green');
p3.XDataSource = 'x_p3'; p3.YDataSource = 'y_p3';

xlim([0 3e3]);
ylim([0 3e3]);
grid on
axis equal

display_goto = 0;
debugg = 1;

% LOS Lookahead-based steering algorithm
idx = 1;
for k = 1:n-1
    % [Book: Iterate on waypoints if and only if distance < 2lenght(USV)]
    % Last waypoint still not being reached
    if idx + 1 ~= length(waypoints)
        % See whether it can go towards the next waypoint
        % Condition: the distance between the AUV and the current waypoint
        % should be less than R
        if norm([x(k), y(k)] - [waypoints(idx + 1, 1), waypoints(idx + 1, 2)]) < R
            if display_goto
                str = compose('Go to (%d, %d)', waypoints(idx + 2, 1), waypoints(idx + 2, 2));
                ha = annotation('textarrow', 'String', str);
                ha.Parent = fig.CurrentAxes;
                ha.X = [250 0] + waypoints(idx + 1, 1);
                ha.Y = [250 0] + waypoints(idx + 1, 2);
            end

            idx = idx + 1;
        end
    % Last waypoint is being reached
    else
        % If last waypoint is being reached, then continue till the distance is
        % less than 5 meters
        if norm([x(k), y(k)] - [waypoints(idx + 1, 1), waypoints(idx + 1, 2)]) < 5
            if display_goto
                ha = annotation('textarrow', 'String', 'Destination was reached');
                ha.Parent = f.CurrentAxes;
                ha.X = [250 0] + waypoints(idx + 1, 1);
                ha.Y = [250 0] + waypoints(idx + 1, 2);
            end
            % Return just the useful data parts
            final_k = k;
            t = t(1:final_k); x = x(1:final_k); y = y(1:final_k); phi = phi(1:final_k); r = r(1:final_k);
            x_los = x_los(1:final_k); y_los = y_los(1:final_k);
            break
        end
    end

    alpha(k) = atan2(waypoints(idx + 1, 2) - waypoints(idx, 2), waypoints(idx + 1, 1) - waypoints(idx, 1));
    e(k) = -(x(k) - waypoints(idx, 1)) * sin(alpha(k)) + (y(k) - waypoints(idx, 2)) * cos(alpha(k));
    if k ~= 1
        int_e(k) = int_e(k - 1) + e(k) * delta_t;
    end
    delta(k) = sqrt(R^2 - e(k)^2);
    Kp_los(k) = 1 / delta(k);
    chi_r(k) = atan(-Kp_los(k) * e(k) - Ki_los * int_e(k)); 
    
    phi_d(k) = alpha(k) + chi_r(k);
    phi_err(k) = phi(k) - phi_d(k);
    if k ~= 1
        int_phi_err(k) = int_phi_err(k - 1) + phi_err(k) * (t(k) - t(k - 1));
    end
    u(k) = -Kp * phi_err(k) - Ki * int_phi_err(k); 

    % Compute kinematics
    delta_t = t(k + 1) - t(k);
    r(k + 1) = r(k) + 1 / T * (K * u(k) - r(k)) * delta_t;
    phi(k + 1) = phi(k) + r(k + 1) * delta_t;
    x(k + 1) = x(k) + V * cos(phi(k));
    y(k + 1) = y(k) + V * sin(phi(k));

    % Refresh and print data
    x_p4 = x(1:k); y_p4 = y(1:k);
    [x_p2, y_p2] = circ(x(k), y(k), R);
    x_p3 = x(k); y_p3 = y(k);

    if debugg 
        fprintf('%-10.2f', x(k));
        fprintf('%-20.6f', y(k));
    
        fprintf('%-10.2f', degrees(phi(k)));
        fprintf('%-10.2f', degrees(phi_d(k)));
        fprintf('%-10.2f', degrees(phi_err(k)));

        fprintf('\n');
    end

    refreshdata
    drawnow
end


function deg = degrees(rad)
    deg = rad * 180 / pi;
end