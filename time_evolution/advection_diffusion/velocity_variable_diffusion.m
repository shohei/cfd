function velocity_variable_diffusion

clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CAPTURE = false;
VIEWTOP = true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%condition
deltaT = 0.1;
D=0.05;
xmax=2;
ymax=2;
xwidth=31;
ywidth=31;
x=linspace(0,xmax,xwidth);
y=linspace(0,ymax,ywidth);
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
% u = uconst*ones(size(X));
% u = uconst*(X.*(X>0)) + (-uconst)*(X.*(X<0));
% u = uconst*(X);
u = uconst*abs(X);

% v = 0*Y;
vconst = 0.2;
% v = vconst*ones(size(Y));
v = vconst*abs(Y);


vcomp = u+v;

%check CFL condition
cx = abs(u*deltaT/dx);
cy = abs(v*deltaT/dy);
if (~isempty(find(cx>=1)) || ~isempty(find(cy>= 1)))
    disp 'CFL condition not satisfied. Exit program.'
    return;
else
    msg = sprintf('Max courant number is %f. Go for it.',max(max(cx(:)),max(cy(:))));
    msg
end

FigHandle = figure;
set(FigHandle, 'Position', [100, 100, 1200, 400]);

ax1 = subplot(131);
axis equal;
% contour(Y,X,f,100,'LineColor','red');
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


solveCIP();
reflectVelocityPartial();
solveDiffusion();

for step = 1:300
    solveCIP()
    %     surf(X,Y,F); %this swaps X and Y axes.
    % Somehow, matrix definition and axis direction swaps. sad though.
       
    reflectVelocityPartial(); %update f
    [g,h] = gradient(f);

%     contour(Y,X,F,100,'LineColor','red');
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

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function solveCIP()
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
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%secondly, compute with ...
    function reflectVelocityPartial
        g = f;
        for j=2:ywidth-1
            for i=2:xwidth-1
                g(i,j) = F(i,j) - f(i,j) * ((u(i+1,j)-u(i-1,j))/(2*dx) + (v(i,j+1)-v(i,j-1))/(2*dy));
            end
        end
        f = g;
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%finally, ....
    function solveDiffusion
        
    end

if(CAPTURE)
    close(writerObj);
end

end