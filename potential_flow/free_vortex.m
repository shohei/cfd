function free_vortex

clear all;
close all;

x=-2.0:0.1:2.0;
y=-2.0:0.1:2.0;
[X,Y] = meshgrid(x,y);

r=sqrt(X.^2+Y.^2);
theta = atan2(Y,X);
gamma = 1.0;

Phi = gamma/(2*pi)*theta;
Psi = -gamma/(2*pi)*log(r);

contour(X,Y,Phi,10,'LineColor','red');
hold on;
contour(X,Y,Psi,10,'LineColor','blue');

end