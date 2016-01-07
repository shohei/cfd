function advection_x

clear all;
close all;
format shortG;
courant=1;
deltaT=0.1;
partition=101;
pulseWidth=1;
speed=1;
thinningN=1;

xmax=10;
xx=linspace(0,xmax,101)';

global d; global h;
d=0.4; h=1.2;
global A; A=1;
a=A/d;
b=A*(2*d+h)/d;
I=ones(size(xx,1),1);
u=2;
xlim([0 xmax]);
ylim([0 1.2*A]);

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

drawWave();

    function drawWave()
        for t=0:0.1:4
            x=xx-u*t;
            rising =a*x.*(x>=0 & x<d);
            holding = A*I.*(x>=d & x<=h+d);
            falling = (-a*x+b*I).*(x>h+d & x<=2*d+h);
            fx=rising+holding+falling;
            
            axes(sp1);
            h1=drawOne(t,fx);
            
            axes(sp2);
            h2=drawTwo(t,fx);
            
            axes(sp3);
            h3=drawThree(t,fx);
            
            axes(sp4);
            h4=drawFour(t,fx);

            drawnow;
            
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

    function h1=drawOne(t,fx)
        h1=plot(xx,fx,'b-');
    end

    function h2=drawTwo(t,fx)
        h2=plot(xx,fx,'b-');
    end

    function h3=drawThree(t,fx)
        h3=plot(xx,fx,'b-');
    end

    function h4=drawFour(t,fx)
        h4=plot(xx,fx,'b-');
    end

end