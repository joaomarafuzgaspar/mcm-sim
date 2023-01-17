x_fun = @(t) t;

mu = [1000; 1000];
sigma = 5;
Sigma = diag([sigma sigma]);
phi = @(omega) 1 / (2 * pi * sqrt(det(Sigma))) * exp(-1/2 * (omega - mu)' * inv(Sigma) * (omega - mu));
alpha = ones(length(phi));

beta = 1.9;
F = 120;
D = 0.45;
b = 20;
sigma = 150;
gamma = @(x, omega) beta * normcdf((F - D * norm(x - omega).^2 - b) / sigma);

x0 = [2500 2500 pi 0 500 500];
A = [];
b = [];
Aeq = [];
beq = [];
lb = [];
ub = [];
nonlcon = @constraint;

% Set any necessary options for fmincon
options = optimoptions(@fmincon, 'Algorithm', 'interior-point');

% Call fmincon to minimize the objective function subject to the constraints
fmincon(@J, x0, A, b, Aeq, beq, lb, ub, nonlcon, options);

function cost = J(params)
    x = params(1:4, :);
    omega = params(5:6, :);
    for i = 1:M
        cost = cost + exp(-integral(@(t) gamma(x_fun(t), omega(i)), 0, 1, 'ArrayValued', true)) .* phi(omega(i)) .* alpha(i);
    end
end

function [c, ceq] = constraint(x)
    
end