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
global x; x=linspace(0,1,partition);
totalT=5;
delay=0.5;
% first_order_upwind;
% second_order_upwind;
% cip;
% exact_solution;
ylim([-10 10]);
xlim([0 totalT]);
hold on;
ts=0:deltaT:totalT;
for time=ts
    cla;
    time
    drawPulse(time);
    drawnow;
    pause(deltaT)
end

    function fx=computeFx(x)
        a = 1/delay;
        b = (1+2*delay)/delay;
        fx = a*x.*(x<delay)+...
            1*(x>delay & x<1+delay)+...
            (-a*x+b).*(x>1+delay & x<1+2*delay);
    end

    function y=computePulse(t)
        y = computeFx(x-speed*t);
    end

    function drawPulse(t)
        y=computePulse(t);
        plot(x,y);
    end


end