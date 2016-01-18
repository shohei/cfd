function diff2d_constD
clear all;
close all;

% use surf() function for visualization

xmax=2;
ymax=2;
deltaT = 0.1;
D=0.05;
% dx=D*(deltaT)/()
% dy=

xwidth=31;
ywidth=31;
x=linspace(-xmax,xmax,xwidth);
diffx=diff(x);
dx=diffx(1);
y=linspace(-ymax,ymax,ywidth);
diffy=diff(y);
dy=diffy(1);
[X,Y]=meshgrid(x,y);
dix=D*deltaT/(dx)^2
diy=D*deltaT/(dy)^2

%initialize
radius=1;
Amp=xmax;
f = Amp*(X.^2+Y.^2<=radius);
% contour(X,Y,f)
shading interp
% shading flat;
surf(X,Y,f);
zlim([0 Amp*1.2]);
% contourf(X,Y,f)
% imagesc(f);
axis equal;
% az = 0;
% el = 90;
% view(az, el);
colormap(hot);

writerObj = VideoWriter('newfile.avi');
open(writerObj);

f_next=f;
for t=1:30
    for m=2:ywidth-1 %yscan
        for n=2:xwidth-1 %xscan
            f_next(m,n) = f(m,n) + dix*(f(m,n+1)-2*f(m,n)+f(m,n-1))+...
                diy*(f(m+1,n)-2*f(m,n)+f(m-1,n));
            f=f_next;
        end

        %     contourf(X,Y,f)
        surf(X,Y,f);
        zlim([0 Amp*1.2]);
        colormap(hot);
%         az = 0;
%         el = 90;
%         view(az, el);
        drawnow;
        zlim([0 Amp*1.2]);

        frame = getframe(gcf);
        writeVideo(writerObj, frame);

    end
    fprintf('t=%d \n',t);    
end

close(writerObj);


end
