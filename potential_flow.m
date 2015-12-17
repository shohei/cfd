function potential_flow

x=0:0.1:10;
y=0:0.1:10;
[X,Y] = meshgrid(x,y);
U=1.0;
alpha_deg=5;
alpha=alpha_deg/180.0*pi;
Phi = U*(X.*cos(alpha)+Y.*sin(alpha));
Psi = U*(Y.*cos(alpha)-X.*sin(alpha));
contour(Phi,'LineColor','red');
hold on;
contour(Psi,'LineColor','blue');


end