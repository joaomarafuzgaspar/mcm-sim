function simpsons_rule(Omega)
    % Define the function f and the integration limits
    mu = [10; 10];
    sigma = 5;
    Sigma = diag([sigma sigma]);
    
    f = @(omega_x, omega_y) 1 / (2 * pi * sqrt(det(Sigma))) * exp(-1/2 ...
        * ([omega_x; omega_y] - mu)' * inv(Sigma) * ([omega_x; omega_y] - mu));
    
    omega_x_min = min(Omega(1, :));
    omega_x_max = max(Omega(1, :));
    omega_y_min = min(Omega(2, :));
    omega_y_max = max(Omega(2, :));
    
    % Divide the x and y intervals into a number of subintervals
    Nx = 10;
    Ny = 10;
    dx = (omega_x_max - omega_x_min) / Nx;
    dy = (omega_y_max - omega_y_min) / Ny;
    
    % Initialize the integral value
    I = 0;
    
    % Loop over the x and y subintervals
    for i = 1:Nx
      for j = 1:Ny
        % Compute the integration weights
        wx = 1;
        wy = 1;
        if i == 1 || i == Nx
          wx = wx / 2;
        end
        if j == 1 || j == Ny
          wy = wy / 2;
        end
    
        % Compute the integral over the current subinterval
        x1 = omega_x_min + (i - 1) * dx;
        x2 = omega_x_min + i * dx;
        y1 = omega_y_min + (j - 1) * dy;
        y2 = omega_y_min + j * dy;
        I = I + wx * wy * (f(x1, y1) + 4 * f((x1 + x2) / 2, (y1 + y2) / 2) + f(x2, y2));
      end
    end
    
    % Scale the integral by the size of the subintervals
    I = I * dx * dy / 9;
    
    % Print the result
    fprintf('I = %f\n', I);
end