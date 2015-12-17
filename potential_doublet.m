function potential_doublet

clear all;
close all;

x=-2:0.1:2;
y=-2:0.1:2;
[X,Y] = meshgrid(x,y);

k=1.0;

Phi = k*X./(X.^2+Y.^2);
Psi = -k*Y./(X.^2+Y.^2);

contour(X,Y,Phi,50,'LineColor','red');
hold on;
contour(X,Y,Psi,50,'LineColor','blue');




end