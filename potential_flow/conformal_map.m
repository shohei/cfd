function conformal_map
clear all;close all;
xi_x = -2:0.1:2;
xi_y = -2:0.1:2;
[X,Y] = meshgrid(xi_x,xi_y);
Xi = X + i*Y;

R=1;
alpha_deg = 20;
alpha=alpha_deg/180*pi;
Z = Xi + R^2./Xi*exp(-i*2*alpha);

axis equal;
xlim([-2 2]);
ylim([-2 2]);

% contour(X,Y,abs(Xi));
hold on;
contour(X,Y,abs(Z));

end