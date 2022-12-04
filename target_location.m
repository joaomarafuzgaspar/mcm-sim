function target_probability = target_location(n)

    omega_x = linspace(-2, 2, n);
    omega_y = linspace(-2, 2, n);
    [omega_X, omega_Y] = meshgrid(omega_x, omega_y);
    target_probability = exp(-10 * (omega_X.^2 + omega_Y.^2) / 1^2);

    image(target_probability, 'CDataMapping', 'scaled');

    c = colorbar;
    set(c, "TickLabelInterpreter", "latex");
    set(c, "fontsize", 14); 
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
    xticks([0:500:3000]);
    xticklabels([0:5:30]);
    yticks([0:500:3000]);
    yticklabels([0:5:30]);
end