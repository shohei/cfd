function uniform_doublet_vortex

clear all;
close all;

x=-2.0:0.1:2.0;
y=-2.0:0.1:2.0;
[X,Y] = meshgrid(x,y);

U=2.0;
alpha_deg=0;
alpha=alpha_deg/180.0*pi;
R=0.8;
r=sqrt(X.^2+Y.^2);
theta = atan2(Y,X);
gamma = - 5.0;


Phi = U*(r+R^2./r).*cos(theta-alpha) + gamma/(2*pi)*(theta-alpha);
Psi = U*(r-R^2./r).*sin(theta-alpha) - gamma/(2*pi)*log(r);

subplot(1,2,1);
contour(X,Y,Phi,50,'LineColor','red');
hold on;
contour(X,Y,Psi,50,'LineColor','blue');
axis equal;
title('doublet in uniform flow (with CCW vortex)');

t = linspace(0,2*pi,100);
patch(R*sin(t),R*cos(t),'yellow','FaceAlpha',0.2);

subplot(1,2,2);
doublet_in_uniform_flow;
axis equal;
title('doublet in uniform flow');

end