beta = 1.9;
F = 120;
D = 0.45;
b = 20;
sigma = 150;

M = 3;
Omega = randi([0 3e3], 2, M);

x_fun = @(t) t;
gamma = @(x, omega) beta * normcdf((F - D * norm(x - omega).^2 - b) / sigma);
J_fun = @(omega) exp(-integral(@(t) gamma(x_fun(t), omega), 0, 1, 'ArrayValued', true));

mu = [10; 10];
sigma = 5;
Sigma = diag([sigma sigma]);
phi = @(omega) 1 / (2 * pi * sqrt(det(Sigma))) * exp(-1/2 * (omega - mu)' * inv(Sigma) * (omega - mu));

[xval, omegaval, fval, output] = fminbnd(J_fun, -1, 1);
fprintf('Optimal values: x = %6f, omega = %6f\n', xval, omegaval);
