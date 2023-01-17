function [x, y] = circ( x_center,  y_center, radius)
    angles = 0:pi/50:2 * pi;
    x = x_center + radius * cos(angles);
    y = y_center + radius * sin(angles);
end