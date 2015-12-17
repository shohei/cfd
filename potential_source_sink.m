function potential_source_sink

clear all;
close all;

x=-10:0.2:10;
y=-10:0.2:10;
[X,Y] = meshgrid(x,y);

Q=1.0;
a = 2.0;
r1=sqrt((X+a).^2+Y.^2);
r2=sqrt((X-a).^2+Y.^2);
theta1 = atan2(Y,(X+a));
theta2 = atan2(Y,(X-a));

U=1.0;
alpha_deg=5;
alpha=alpha_deg/180.0*pi;
% Phi = U*(X.*cos(alpha)+Y.*sin(alpha));
% Psi = U*(Y.*cos(alpha)-X.*sin(alpha));
Phi = Q/(2*pi) * log(r1./r2);
Psi = Q/(2*pi) * (theta1-theta2);

contour(Phi,20,'LineColor','red');

hold on;
contour(Psi,20,'LineColor','blue');



end