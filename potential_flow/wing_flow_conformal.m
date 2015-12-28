function wing_flow_conformal

clear all;close all;
R=0.8;
U=10;
alpha_deg = 20;
alpha = alpha_deg/180*pi;
gamma = -4*pi*R*U*sin(alpha);
rho = 10;
x=-2:0.05:2;
y=-2:0.05:2;
[X,Y] = meshgrid(x,y);
Xi= X +i*Y; 
xi0 = -0.12;
eta0 = 0.52;
Rdash = R*sqrt((1-xi0/R)^2+(eta0/R)^2);
% W = U*(Xi + R^2./Xi*exp(-2*i*alpha));
W = U*(Xi + R^2./Xi*exp(-2*i*alpha)) -i*gamma/(2*pi)*log(Xi);
% Wdash = (R'/R*W + xi0 + R^2./((Rdash/R)*W+xi0))*exp(-i*alpha);
Phi = real(W);
Psi = imag(W);
subplot(1,2,1);
axis equal;
hold on;
contour(X,Y,Phi,100,'LineColor','red');
contour(X,Y,Psi,100,'LineColor','blue');

ncount=1;
drawWing();

%%
subplot(1,2,2);
axis equal;
hold on;
% return;
%not working..........................
z = (R'/R.*Xi + xi0 + R^2./((Rdash/R).*Xi+xi0))*exp(-i*alpha);
w = (U*(exp(-i*alpha)-R^2./(z.^2)*exp(i*alpha))-i*gamma./(2*pi*z))./...
    (Rdash/R-R^2*(Rdash/R).*((Rdash/R)*z+xi0).^2*exp(-2*i*alpha));
WX = real(w);
WY = -imag(w);
% w2 = w.*(abs(w)>8);
% w2X = real(w);
% w2Y = -imag(w);
% vmax =  max(w(w<max(w)));
% [ii,ii] = sort(w);
% vmax = w(ii([2,end-1]));
% vmax = abs(max(w));
% p = 1-(abs(w)/max(abs(vmax)))^2;
thresh = 0.00001
w2 = w.*(abs(w)>thresh*10e+3);
X2 = X.*(abs(w)>thresh*10e+3);
Y2 = Y.*(abs(w)>thresh*10e+3);
p = 1-1/2*rho*abs(w2).^2;
p = p./1e+7;
p(isinf(p))=0;
p = p.*(p>-0.0002);
[cv,ch]=contourf(X2,Y2,p);
% colorbar;
colormap(winter);
set(ch,'edgecolor','none');

ncount=1;
drawWing();


Un=WX./sqrt(WX.^2+WY.^2);
Vn=WY./sqrt(WX.^2+WY.^2);
width=7;
q = quiver(X(1:width:end),Y(1:width:end),Un(1:width:end),Vn(1:width:end));


    function drawWing()
        for theta=linspace(0,2*pi,30)
            cylinder(ncount) = R*exp(i*theta);
            ncount=ncount+1;
        end
        hold on;
        wing = (R'/R*cylinder + xi0 + R^2./((Rdash/R)*cylinder+xi0))*exp(-i*alpha);
        h = plot(wing,'r');
        set(h,'linewidth',2);
    end


end