function test1

clear all; close all;
x=linspace(0,10,21);

global d; global h;
d=1; h=2;
global A; A=1;
a=A/d;
b=a*(2*d+h)/d;
I=ones(size(x,1),1);
u=1;

subplot(3,1,1);
rising =a*x.*(x>=0 & x<d);
holding = A*I.*(x>=d & x<h+d);
falling = (-a*x+b*I).*(x>=h+d & x<=h+2*d);
fx=rising+holding+falling;
plot(x,fx);

subplot(3,1,2);
t=1;
x=x-u*t;
rising =a*x.*(x>=0 & x<d);
holding = A*I.*(x>=d & x<h+d);
falling = (-a*x+b*I).*(x>=h+d & x<=h+2*d);
fx=rising+holding+falling;
plot(x,fx);

subplot(3,1,3);
u=1;
t=2;
x=x-u*t;
rising =a*x.*(x>=0 & x<d);
holding = A*I.*(x>=d & x<h+d);
falling = (-a*x+b*I).*(x>=h+d & x<=h+2*d);
fx=rising+holding+falling;
plot(x,fx);


end