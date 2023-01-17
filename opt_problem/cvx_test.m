% Define the length of the vectors
n = 10;

% Define the variables
cvx_begin
    variables x(2, n) omega(2, n)
    
    % Define the objective function
    minimize(norm(x - omega))
    
    % Define the constraints
    subject to
        x(1, :) >= 0;
        x(1, :) <= 3e3;
        x(2, :) >= 0;
        x(2, :) <= 3e3;

        omega(1, :) >= 0;
        omega(1, :) <= 3e3;
        omega(2, :) >= 0;
        omega(2, :) <= 3e3;
cvx_end

% Print the optimal values of x and omega
disp('Optimal x: ')
disp(x)
disp('Optimal omega: ')
disp(omega)