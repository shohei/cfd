function potential_source

close all;
clear all;

x=-10:0.1:10;
y=-10:0.1:10;
[X,Y] = meshgrid(x,y);

Q=1.0;
r=sqrt(X.^2+Y.^2);

U=1.0;
alpha_deg=5;
alpha=alpha_deg/180.0*pi;
Phi = Q/(2*pi) * log(r);
Psi = Q/(2*pi) * atan2(Y,X);

contour(Phi,20,'LineColor','red');
hold on;
contour(Psi,20,'LineColor','blue');



end