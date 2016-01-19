function diff2d_constD
clear all;
close all;

% use surf() function for visualization

xmax=2;
ymax=2;
deltaT = 0.1;
% D=0.05;
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
yoffset = 0.3;
D = 0.04*(Y<yoffset & Y>-yoffset) + 0.01*(Y>=yoffset | Y<=-yoffset);

%initialize
radius=0.05;
Amp=xmax;
f = Amp*((X+1).^2+Y.^2<=radius);
shading interp
surf(X,Y,f);
zlim([0 Amp*1.2]);
axis equal;
% viewTop();
colormap(hot);

writerObj = VideoWriter('newfile.avi');
open(writerObj);

f_next=f;
for t=1:30
    for m=2:ywidth-1 %yscan
        for n=2:xwidth-1 %xscan
            d = D(m,n)*deltaT/(dx)^2;
            if d>0.25
                fprintf('invalid d=%.2f\n',d);
                disp 'break program';
                return;
            end
            some= deltaT/(4*dx^2)*((D(m,n+1)-D(m,n-1))*(f(m,n+1)-f(m,n-1))+(D(m+1,n)-D(m-1,n))*(f(m+1,n)-f(m-1,n)));
            f_next(m,n) =f(m,n) +d*(f(m,n+1)-2*f(m,n)+f(m,n-1))+d*(f(m+1,n)-2*f(m,n)+f(m-1,n))+some;                
            f=f_next;
        end
        surf(X,Y,f);
        zlim([0 Amp*1.2]);
        colormap(hot);
%         viewTop();
        drawnow;

        frame = getframe(gcf);
        writeVideo(writerObj, frame);

    end
    fprintf('t=%d \n',t);    
end

close(writerObj);

    function viewTop()
        az = 0;
        el = 90;
        view(az, el);        
    end


end
