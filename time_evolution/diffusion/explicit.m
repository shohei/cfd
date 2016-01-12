function diff1d
clear all;
close all;

d=1;
A=1;
xmax=5;
partition=101;
x=linspace(-xmax,xmax,partition);

fx=A*(x>-d/2 & x<d/2);
plot(x,fx);
xlim([-xmax xmax]);
ylim([0 1.2*A]);

% subplot();










end