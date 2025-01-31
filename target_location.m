function target_probability = target_location(x, y, mu, Sigma)
    
    [omega_X, omega_Y] = meshgrid(0:0.1:30);
    target_probability = zeros(length(omega_X), length(omega_Y));
    for i = 1:length(omega_X)
        for j = 1:length(omega_Y)
            target_probability(j, i) = 1 / (2 * pi * sqrt(det(Sigma))) * exp(- 1/2 * ([omega_X(j, i); omega_Y(j, i)] - mu)' * inv(Sigma) * ([omega_X(j, i); omega_Y(j, i)] - mu));
        end
    end

    pcolor(omega_X, omega_Y, target_probability);
    %axis equal
    shading interp;

    c = colorbar;
    set(c, "TickLabelInterpreter", "latex");
    set(c, "fontsize", 14); 
    clim([0, inf]);
    c.Label.String = 'Probability';
    c.Label.Interpreter = 'latex';
    c.Label.Rotation = -90;
    c.Label.Position = [4 0.4468 0];
    c.Label.FontSize = 18;
    colormap(jet(4096))

    set(gca, "TickLabelInterpreter", "latex");
    set(gca, "fontsize", 14); 
    set(gca,'YDir','normal')
    xlabel("Easting (DU)", "Interpreter", "latex", "fontsize", 18);
    ylabel("Northing (DU)", "Interpreter", "latex", "fontsize", 18);
    title("Target Location", "Interpreter", "latex", "fontsize", 18);
    
    target_probability = zeros(1, length(x));
    for i = 1:length(x)
        target_probability(i) = 1 / (2 * pi * sqrt(det(Sigma))) * exp(- 1/2 * ([x(i); y(i)] - mu)' * inv(Sigma) * ([x(i); y(i)] - mu));
    end
end