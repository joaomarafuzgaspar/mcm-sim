function [x, y, phi, r, t] = los_controller(waypoints)

    % Initializations
    n = 4602;
    t = linspace(0, 3600, n);
    
    x = zeros(1, n);
    y = zeros(1, n);
    phi = zeros(1, n);
    r = zeros(1, n);
    
    x(1) = 500;
    y(1) = 500;
    phi(1) = 0;
    r(1) = 0;
    
    x_los = zeros(1, n);
    y_los = zeros(1, n);
    phi_d = zeros(1, n);
    phi_err = zeros(1, n);
    int_phi_err = 0;
    u = zeros(1, n);
    
    Kp = 1;
    Ki = 0.043;
    R = 100;
    
    % USV Kinematic Model (Nomoto)
    V = 2.5; % [m/s]
    T = 5.0; % [s]
    K = 0.5; % [1/s]
    
    % LOS Enclosure-based steering algorithm
    idx = 1;
    for k = 1:n-1
        % Iterate on waypoints if and only if distance > 2 * lenght(USV)
        if idx + 1 ~= length(waypoints)
            if norm([x(k), y(k)] - [waypoints(idx + 1, 1), waypoints(idx + 1, 2)]) < 100
                idx = idx + 1;
            end
        else
            if norm([x(k), y(k)] - [waypoints(idx + 1, 1), waypoints(idx + 1, 2)]) < 1
                break;
            end
        end
    
        if idx+1 > length(waypoints)
            break;
        end
        % Compute de x_los and y_los
        % |∆x| > 0
        if abs(waypoints(idx + 1, 1) - waypoints(idx, 1)) > 0
            d = (waypoints(idx + 1, 2) - waypoints(idx, 2)) / (waypoints(idx + 1, 1) - waypoints(idx, 1));
            e = waypoints(idx, 1); f = waypoints(idx, 2);
            g = f - d * e;
            a = 1 + d^2;
            b = 2 * (d * g - d * y(k) - x(k));
            c = x(k)^2 + y(k)^2 + g^2 - 2 * g * y(k) - R^2;
            % ∆x > 0
            if waypoints(idx + 1, 1) - waypoints(idx, 1) > 0
                x_los(k) = (-b + sqrt(b^2 - 4 * a * c)) / (2 * a);
            % ∆x < 0
            else
                x_los(k) = (-b - sqrt(b^2 - 4 * a * c)) / (2 * a);
            end
            y_los(k) = d * (x_los(k) - waypoints(idx, 1)) + waypoints(idx, 2);
        % ∆x = 0
        else
            x_los(k) = waypoints(idx, 1);
            % ∆y > 0
            if waypoints(idx + 1, 2) - waypoints(idx, 2) > 0
                y_los(k) = y(k) + sqrt(R^2 - (x_los(k) - x(k))^2);
            % ∆y < 0
            else
                y_los(k) = y(k) - sqrt(R^2 - (x_los(k) - x(k))^2);
            end
        end
        
        % Compute errors and control signal
        phi_d(k) = atan2(y_los(k) - y(k), x_los(k) - x(k));
        phi_err(k) = phi(k) - phi_d(k);
        if k == 1
            int_phi_err = 0;
        else
            int_phi_err = int_phi_err + (phi_err(k) + phi_err(k - 1)) / 2 * (t(k) - t(k - 1));
        end
        u(k) = -Kp * phi_err(k) - Ki * int_phi_err; 
    
        % Compute kinematics
        delta_t = t(k + 1) - t(k);
        r(k + 1) = r(k) + 1 / T * (K * u(k) - r(k)) * delta_t;
        phi(k + 1) = phi(k) + r(k) * delta_t;
        x(k + 1) = x(k) + V * cos(phi(k));
        y(k + 1) = y(k) + V * sin(phi(k));
    end

    x = x / 100;
    y = y / 100;
    
    % Plot
%     plot(x/100, y/100, "LineWidth", 2);
%     xlim([0 30])
%     ylim([0 30])
%     grid on

end