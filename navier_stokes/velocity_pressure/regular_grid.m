function regular_grid
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%
CAPTURE = false;
%%%%%%%%%%%%%%%%%%%%%%%%%

MAXLOOP = 1000;
tolelance = 1e-10;

Xcav = 0.8;
WcavX = 0.4;
WcavY = 0.4;

L = 2;
W = 1;

dx = 0.05;
dy = 0.05;
x = 0:dx:L;
y = 0:dy:(W+WcavY);
[X,Y] = meshgrid(x,y);
dt = 0.01;

%% draw cavity
figure();
hold on;
drawCavity();

    function drawCavity()
        plot([0,Xcav-WcavX/2],[WcavY,WcavY],'k');
        plot([Xcav-WcavX/2,Xcav-WcavX/2],[WcavY,0],'k');
        plot([Xcav-WcavX/2,Xcav+WcavX/2],[0,0],'k');
        plot([Xcav+WcavX/2,Xcav+WcavX/2],[0,WcavY],'k');
        plot([Xcav+WcavX/2,L],[WcavY,WcavY],'k');
        plot([0,L],[W,W],'k')        
        title('VELOCITY IN CAVITY');
        patch([0 Xcav-WcavX/2 Xcav-WcavX/2 0],...
            [0 0 WcavY WcavY],'k');
        patch([Xcav+WcavX/2 Xcav+WcavX/2 L L],...
            [0 WcavY WcavY 0],'k');        
    end

    function drawVelocity()
        drawCavity();
        contour(X,Y,Phi,10,'LineColor','red');
        patch([Xobs-WobsX/2 Xobs-WobsX/2 Xobs+WobsX/2 Xobs+WobsX/2],...
            [0 WobsY WobsY 0],'k');
        drawnow limitrate;
        if(CAPTURE)
            frame = getframe(gcf);
            writeVideo(writerObj, frame);
        end
    end

    function drawPressure()
        
    end


%% initial condition
u = 0*X;
v = 0*X;
for yi=1:size(Y,1)
    for xi=1:size(X,2)
        if(X(xi,yi) > Xobs-WobsX/2 && X(xi,yi) < Xobs+WobsX/2 && Y(xi,yi) < WobsY)
            continue;
        else
            u(xi,yi) = U*xi;
            v(xi,yi) = U*yi;
        end
    end
end

% u = 2*X;
% v = 2*Y;
% 
% surf(X,Y,u);


% checkCFLcondition();

%% main routine
for time=1:100    
    for count=1:MAXLOOP
        for j=2:length(u)-1
            for i=2:length(u)-1
                us(i,j) = u(i,j) - dt*(...
                    u(i,j)*(u(i+1,j)-u(i-1,j))/(2*dx) + ...
                    v(i,j)*(v(i,j+1)-v(i,j-1))/(2*dy) + ...
                    (1/Re)*(...
                    (u(i+1,j)-2*u(i,j)+u(i+1,j))/(dx^2)+...
                    (u(i,j+1)-2*u(i,j)+u(i,j-1))/(dy^2)));
                vs(i,j) = v(i,j) - dt*(...
                    u(i,j)*(v(i+1,j)-v(i-1,j))/(2*dx) + ...
                    v(i,j)*(v(i,j+1)-v(i,j-1))/(2*dy) + ...
                    (1/Re)*(...
                    (v(i+1,j)-2*v(i,j)+v(i+1,j))/(dx^2)+...
                    (v(i,j+1)-2*v(i,j)+v(i,j-1))/(dy^2)));
                D(i,j) = 1/dt*(...
                    (us(i+1,j)-us(i-1,j))/(2*dx) + ...
                    (us(i,j+1)-us(i,j-1))/(2*dy));
                q(i,j) = (dx*dy)^2/(2*(dx^2+dy^2)) * (...
                    p(i+1,j)+p(i-1,j)/dx^2 + ...
                    p(i,j+1)+p(i,j-1)/dy^2 - ...
                    D(i,j));
            end
        end
        min(min(p(:))-min(q(:)))
        if(min(min(p(:))-min(q(:))) < tolerance)
            disp 'tolerance satisfied';
            break;
        end
    end
    u(i,j) = us(i,j) - dt*(p(i+1,j)-p(i-1,j))/(2*dx);
    v(i,j) = vs(i,j) - dt*(p(i,j+1)-p(i,j-1))/(2*dy);
    
    surf
end


end