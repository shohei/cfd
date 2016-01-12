function test_animation

clear all; close all;
xmax=10;
xx=linspace(0,xmax,101)';

global d; global h;
d=0.4; h=1.2;
global A; A=1;
a=A/d;
b=A*(2*d+h)/d;
I=ones(size(xx,1),1);
u=2;
hold on;

drawWave();

    function drawWave()
        for t=0:0.1:4
            x=xx-u*t;
            rising =a*x.*(x>=0 & x<d);
            holding = A*I.*(x>=d & x<=h+d);
            falling = (-a*x+b*I).*(x>h+d & x<=2*d+h);
            fx=rising+holding+falling;
            h1=plot(xx,fx,'b-');
            xlim([0 xmax]);
            ylim([0 1.2*A]);
            drawnow;
            pause(0.1);
            if ((t==0)||(t==1)||(t==2)||(t==3)||(t==4))
                set(h1,'Visible','on');
            else
                set(h1,'Visible','off');
            end
        end        
    end

end