function pressure_map

clear all;
close all;

def = 2;

x=-def:0.1:def;
y=-def:0.1:def;
[X,Y] = meshgrid(x,y);

U= 2.0;
alpha_deg=0;
alpha=alpha_deg/180.0*pi;
R=0.8;
r=sqrt(X.^2+Y.^2);
theta = atan2(Y,X);
gamma = -15.0;
rho = 10.0;

Phi = U*(r+R^2./r).*cos(theta-alpha) + gamma/(2*pi)*(theta-alpha);
Psi = U*(r-R^2./r).*sin(theta-alpha) - gamma/(2*pi)*log(r);

%% ???????? & ???????
subplot(1,2,1);
contour(X,Y,Phi,20,'LineColor','red');
hold on;
contour(X,Y,Psi,20,'LineColor','blue');
t = linspace(0,2*pi,100);
patch(R*sin(t),R*cos(t),'yellow','FaceAlpha',0.4);
title('Velocity potential and stream function');
axis equal;

%% ???? & ?????????
subplot(1,2,2);
hold on;
Z = X + i.*Y;
% TODO: ??????i????????????????...?
w = U*(1-R^2./Z.^2)+i*gamma/(2*pi)./Z;
WX = real(w);
WY = imag(w);
W = sqrt(WX.^2+WY.^2);
% ??
W2 = W.*(W<8);
p = 1 - 1/2.0 * rho * W2.^2;
[cv,ch] = contourf(X,Y,p,20);
colormap(winter);
axis equal;
title('Pressure and velocity vector');
set(ch,'edgecolor','none');
axis equal;
hold on;

% ??
t = linspace(0,2*pi,100);
patch(R*sin(t),R*cos(t),'yellow','FaceAlpha',0.9);

% ??????
Un=WX./sqrt(WX.^2+WY.^2);
Vn=WY./sqrt(WX.^2+WY.^2);
width=3 ;
q = quiver(X(1:width:end),Y(1:width:end),Un(1:width:end),Vn(1:width:end));

end