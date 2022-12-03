% x = linspace(-2,2,1000);
% y = linspace(-2,2,1000);
% [X,Y] = meshgrid(x,y);
% intensity = exp(-10 * ((X - 0.5).^2 + Y.^2) / 1^2);
% figure
% image(intensity,'CDataMapping','scaled')
% colorbar
% colormap(jet(4096))


n = 100;
x = linspace(5, 25, n);
y = cos(2 * x) + x;
t = linspace(0, 10, n + 1);
u = rand(1, n);

for i = 1:n
    plot(x(1:i), y(1:i), "LineWidth", 2);
    hold on
    plot(x(i), y(i), 'or', 'MarkerSize', 5, 'MarkerFaceColor', 'r')
    hold off
    set(gca, "TickLabelInterpreter", "latex");
    set(gca, "fontsize", 14); 
    xlabel("Easting (DU)", "Interpreter", "latex", "fontsize", 18);
    ylabel("Northing (DU)", "Interpreter", "latex", "fontsize", 18);
    xlim([0, 30])
    ylim([0, 30])
    grid on
    grid minor
    pause(.1)
end
close

% USV Kinematic Model (Nomoto)
% V = 2.5; % [m/s]
% T = 5.0; % [s]
% K = 0.5; % [1/s]
% x_dot = V * cos(phi);
% y_dot = V * sin(phi);
% phi_dot = r;
% r_dot = 1 / T  * (K * u - r);

% crc = @(r,p,t,om) [r*cosd(om.*t + p);  r*sind(om.*t + p)];
% t   = linspace(0, 360, 500);                         % Time
% om  = 1 + sin(t);                                    % random angular velocity
% centre = [40; 80];                                           % Circle Centre
% init_pos = atan2d(120-centre(2), 10-centre(1));              % Initial Position (°)
% radius = hypot(10-centre(1), 120-centre(2));                 % Circle Radius
% locus = bsxfun(@plus, crc(radius, init_pos, t, om), centre); % Calculate Circle Locus
% figure(1)
% for k1 = 2:length(t)
%     plot(locus(1,k1),  locus(2,k1), 'gp', 'MarkerFaceColor','g')
%     hold on
%     plot(locus(1,1:k1),  locus(2,1:k1), '-b')
%     hold off
%     axis([0 60 0 160])
%     grid
%     axis equal
%     drawnow
% end

% L0 = 7; L1 = 3; L2 = 7.5; L3 = 4.5;
% L_PA = 4; alpha =35;
% w2 = 5; theta2 = 0:2:360;
% % Convert operators on vectors to elementwise operators
% AC = sqrt(L0^2+L1^2 - 2*L0*L1*cosd(theta2));
% beta = acosd((L0^2+AC.^2-L1^2)./(2*L0*AC));
% psi = acosd((L2^2+AC.^2-L3^2)./(2*L2*AC));
% lamda = acosd((L3^2+AC.^2-L2^2)./(2*L3*AC));
% % These 2 lines might be a little tricky. Break it into parts to figure out how it works.
% theta3 = (theta2<=180).*(psi-beta) + (theta2>180).*(psi+beta);
% theta4 = (theta2<=180).*(180-lamda-beta) + (theta2>180).*(180-lamda+beta);
% Ox = 0; Oy = 0;
% Ax = Ox + L1*cosd(theta2);
% Ay = Oy + L1*sind(theta2);
% Bx = Ox +Ax + L2*cosd(theta3);
% By = Oy +Ay + L2*sind(theta3);
% Cx = L0; Cy = 0;
% Px = Ax +L_PA *cosd(alpha + theta3);
% Py = Ay +L_PA *sind(alpha + theta3);
% theta5 = alpha + theta3;
% % Create the original figure by plotting just the first points in the vectors
% AB = plot([Ox Ax(1)],[Oy Ay(1)], ...
%     [Ax(1) Bx(1)],[Ay(1) By(1)],...
%     [Bx(1) Cx],[By(1) Cy],'LineWidth',3);
% hold on
% ABP = plot([Ax(1) Px(1)],[Ay(1) Py(1)],...
%     [Bx(1) Px(1)],[By(1) Py(1)],'LineWidth',3);
% hold off
% grid on;
% axis equal;
% axis([-5 15 -5 10]);
% % Use the loop to step though all the link positions, updating the corresponding X and Y values
% for i = 2:length(theta2)
%     AB(1).XData = [Ox Ax(i)];
%     AB(1).YData = [Oy Ay(i)];
%     AB(2).XData = [Ax(i) Bx(i)];
%     AB(2).YData = [Ay(i) By(i)];
%     AB(3).XData = [Bx(i) Cx];
%     AB(3).YData = [By(i) Cy];
%     
%     ABP(1).XData = [Ax(i) Px(i)];
%     ABP(1).YData = [Ay(i) Py(i)];
%     ABP(2).XData = [Bx(i) Px(i)];
%     ABP(2).YData = [By(i) Py(i)];
%     drawnow
% end