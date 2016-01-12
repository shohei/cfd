function advection_x

clear all;
close all;
format shortG;
partition=101;
xmax=20;
xx=linspace(0,xmax,partition)';
dxs=diff(xx);
dx=dxs(1);
deltaT=0.02;
u=2;
c=u*deltaT/dx;

global d; global h;
d=0.4; h=1.2;
global A; A=1;
a=A/d;
b=A*(2*d+h)/d;
I=ones(size(xx,1),1);
xlim([0 xmax]);
ymag=1.4;
ylim([0 ymag*A]);

global fx1; global fx2; global fx4;
global f; global g;
global f_next; global g_next;

% first_order_upwind;
% second_order_upwind;
% cip;
% exact_solution;
% hold on;
sp1=subplot(4,1,1);
title('1st-order upwind');
hold on;

sp2=subplot(4,1,2);
title('2nd-order upwind');
hold on;

sp3=subplot(4,1,3);
title('CIP method');
hold on;

sp4=subplot(4,1,4);
title('Exact solution');
hold on;

FigHandle = gcf;
set(FigHandle, 'Position', [100, 100, 1000, 700]);

global fx_init;
fx_init=computeFxInit();

% writerObj = VideoWriter('newfile.avi');
% open(writerObj);
drawWave();
% close(writerObj);

    function drawWave()
        for t=0:deltaT:4
            
            axes(sp1);
            h1=drawFirstUpwind(t);
            
            axes(sp2);
            h2=drawSecondUpwind(t);
            
            axes(sp3);
            h3=drawCIP(t);
            
            axes(sp4);
            h4=drawExact(t);
            
            drawnow;
%             frame = getframe(gcf);
%             writeVideo(writerObj, frame);
            
            if ((t==0)||(t==1)||(t==2)||(t==3)||(t==4))
                set(h1,'Visible','on');
                set(h2,'Visible','on');
                set(h3,'Visible','on');
                set(h4,'Visible','on');
            else
                set(h1,'Visible','off');
                set(h2,'Visible','off');
                set(h3,'Visible','off');
                set(h4,'Visible','off');
            end
        end
    end

    function h1=drawFirstUpwind(t)
        if t==0 % initialize
            fx1=fx_init;
        else
            fx1_next(1) = fx1(1);
            for idx=2:partition
                fx1_next(idx) = fx1(idx)+c*(fx1(idx-1)-fx1(idx));
            end
            fx1 = fx1_next;
        end
        
        h1=plot(xx,fx1,'b-');
        xlim([0 xmax]);
        ylim([0 ymag*A]);
    end

    function h2=drawSecondUpwind(t)
        if t==0 % initialize
            fx2=fx_init;
        else
            fx2_next(1) = fx2(1)-c/2.0*(3*fx2(1));
            fx2_next(2) = fx2(2)-c/2.0*(-4*fx2(1)+3*fx2(2));
            for idx=3:partition
                fx2_next(idx) = fx2(idx)-c/2*(...
                    fx2(idx-2)-4*fx2(idx-1)+3*fx2(idx));
            end
            fx2 = fx2_next;
        end
        
        h2=plot(xx,fx2,'b-');
        xlim([0 xmax]);
        ylim([0 ymag*A]);
    end

    function h3=drawCIP(t)
        if t==0
            f=fx_init;
            fdash=diff(f)/dx;
            g=vertcat(0,fdash);            
            f_next = zeros(size(f));
            g_next = zeros(size(g));
        else
            c0=f(1);
            c1=g(1);
            c2=3*(-f(1))/(dx)^2+(2*g(1))/(dx)^2;
            c3=g(1)/dx^2-2*(f(1))/dx^3;
            f_next(1) = F(c0,c1,c2,c3,-u*deltaT);
            g_next(1) = G(c1,c2,c3,-u*deltaT);
                        
            for idx=2:partition
              c0=f(idx);
              c1=g(idx);
              c2=3*(f(idx-1)-f(idx))/dx^2+(2*g(idx)+g(idx-1))/dx;
              c3=(g(idx)+g(idx-1))/dx^2-2*(f(idx)-f(idx-1))/dx^3;
              f_next(idx) = F(c0,c1,c2,c3,-u*deltaT);
              g_next(idx) = G(c1,c2,c3,-u*deltaT);           
            end
            f=f_next;
            g=g_next;          
        end
        
        h3=plot(xx,f,'b-');
        xlim([0 xmax]);
        ylim([0 ymag*A]);
    end

    function h4=drawExact(t)
        x=xx-u*t;
        rising =a*x.*(x>=0 & x<d);
        holding = A*I.*(x>=d & x<=h+d);
        falling = (-a*x+b*I).*(x>h+d & x<=2*d+h);
        fx4=rising+holding+falling;
        h4=plot(xx,fx4,'b-');
        xlim([0 xmax]);
        ylim([0 ymag*A]);
    end

    function fx=computeFxInit()
        x=xx;
        rising =a*x.*(x>=0 & x<d);
        holding = A*I.*(x>=d & x<=h+d);
        falling = (-a*x+b*I).*(x>h+d & x<=2*d+h);
        fx=rising+holding+falling;
    end

    function ret=F(c0,c1,c2,c3,x)
        ret = c0 + c1*x + c2*x^2 + c3*x^3;
    end

    function ret=G(c1,c2,c3,x)
        ret = c1 + 2*c2*x + 3*c3*x^2;
    end

end