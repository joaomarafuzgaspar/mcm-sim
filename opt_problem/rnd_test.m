fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
x0 = [-1,1];
A = [1,10];
b = 1;
x = fmincon(fun,x0,A,b)

fun = @(X, Y) 100 * (Y - X.^2).^2 + (1 - X).^2;
[X, Y] = meshgrid(-2:0.1:2, -2:0.1:2);
Z = fun(X, Y);
surf(X, Y, Z);
hold on
fun = @(x)100*(x(2)-x(1)^2)^2 + (1-x(1))^2;
scatter3(x(1), x(2), fun(x), 'red', 'filled')
grid on