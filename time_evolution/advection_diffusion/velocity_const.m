function velocity_const

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CAPTURE = true;
VIEWTOP = false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%condition
deltaT = 0.1;
D=0.05;
xmax=2;
ymax=2;
xwidth=31;
ywidth=31;
x=linspace(-xmax,xmax,xwidth);
y=linspace(-ymax,ymax,ywidth);
diffx=diff(x);
diffy=diff(y);
dx=diffx(1);
dy=diffy(1);
[X,Y]=meshgrid(x,y);
% dix=D*deltaT/(dx)^2
% diy=D*deltaT/(dy)^2

if(CAPTURE)
    writerObj = VideoWriter('newfile.avi');
    open(writerObj);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%firstly, compute with CIP method
gain = 1;
f = gain*(-X.^2+ -Y.^2);
fmin = min(f(:));
foffset = -1 * fmin;
f = f + foffset*ones(size(f));
[g,h] = gradient(f);

uconst = 0.2;
u = uconst*ones(size(X));

% v = 0*Y;
vconst = 0.2;
v = vconst*ones(size(Y));

vcomp = u+v;

%check CFL condition
cx = abs(u*deltaT/dx);
cy = abs(v*deltaT/dy);
if (~isempty(find(cx>=1)) || ~isempty(find(cy>= 1)))
    disp 'CFL condition not satisfied. Exit program.'
    return;
end

FigHandle = figure;
set(FigHandle, 'Position', [100, 100, 1200, 400]);

ax1 = subplot(131);
axis equal;
surf(Y,X,f);
rotate3d on;
title('Initial f');
if(VIEWTOP)
  view(2)   
end
colormap(ax1,hot);

ax2 = subplot(132);
axis equal;
colormap(ax2,spring);
surf(Y,X,vcomp);
rotate3d on;
title('velocity');
if(VIEWTOP)
  view(2)   
end

ax3 = subplot(133);
axis equal;
title('elapsed f');
rotate3d on;
if(VIEWTOP)
  view(2)   
end
colormap(ax3,hot);

for step = 1:300
    for j=2:ywidth
        for i=2:xwidth
            c30(i,j) = ((g(i-1,j) + g(i,j))*dx -2*(f(i,j)-f(i-1,j)))/(dx^3);
            c03(i,j) = ((h(i,j-1) + h(i,j))*dy -2*(f(i,j)-f(i,j-1)))/(dy^3);
            
            c20(i,j) = (3*(f(i-1,j)-f(i,j)) + 2*(g(i-1,j)+2*g(i,j))*dx)/(dx^2);
            c02(i,j) = (3*(f(i,j-1)-f(i,j)) + 2*(h(i,j-1)+2*h(i,j))*dy)/(dy^2);
            
            a(i,j) = f(i,j)-f(i,j-1)-f(i-1,j)+f(i-1,j-1);
            b(i,j) = h(i-1,j) - h(i,j);
            
            c12(i,j) = (-a(i,j)-b(i,j)*dy)/(dx*dy^2);
            c21(i,j) = (-a(i,j)-(g(i,j-1)-g(i,j))*dx)/(dx^2*dy);
            
            c11(i,j) = (-b(i,j) + c21(i,j)*dx^2)/dx;
            
            c10(i,j) = g(i,j);
            
            c01(i,j) = h(i,j);
            
            c00(i,j) = f(i,j);
            
            gzai = -u(i,j)*(deltaT);
            eta = -v(i,j)*(deltaT);
            
            F(i,j) = ...
                ((c30(i,j)*gzai + c21(i,j)*eta + c20(i,j))*gzai + c11(i,j)*eta + c10(i,j))*gzai +...
                ((c03(i,j)*eta + c12(i,j)*gzai + c02(i,j))*eta + c01(i,j))*eta +...
                c00(i,j);
        end
    end
    %     surf(X,Y,F); %this swaps X and Y axes.
    % Somehow, matrix definition and axis direction swaps. sad though.
    surf(Y,X,F);
    title('time evoluted f');
    if(VIEWTOP)
      view(2)   
    end
    msg = sprintf('t=%d \n',step);
    text(xmax,ymax,msg);
    colormap(hot);
    drawnow;
    
    if(CAPTURE)
        frame = getframe(gcf);
        writeVideo(writerObj, frame);
    end
    
    f = F;
    [g,h] = gradient(f);    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%secondly, compute with ...




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%finally, ....



if(CAPTURE)
    close(writerObj);
end

end