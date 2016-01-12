function diff2d_constD
clear all;
close all;

% shading interp
% colormap(jet(8))

xwidth=0.01;
ywidth=0.01;
xmax=1;
ymax=1;

x=-xmax:xwidth:xmax;
y=-ymax:ywidth:ymax;
[X,Y] = meshgrid(x,y);
Z=-log(X.^2+Y.^2);
% contour3(X,Y,Z,30);
surf(X,Y,Z);




end