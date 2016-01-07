function test_concurrent


figure,
subplot(1,2,1),plot(rand(10,1),rand(10,1),'.'),hold on,p1=plot(rand(1),rand(1),'.r')
subplot(1,2,2),plot(rand(10,1),rand(10,1),'.'),hold on,p2=plot(rand(1),rand(1),'.r')

%# read the red coordinates - I should have stored them before plotting :)
x(1) = get(p1,'xdata');y(1)=get(p1,'ydata');x(2)=get(p2,'xdata');y(2)=get(p2,'ydata');

%# animate
for i=1:100,
   delta = randn(1,2)*0.01;
   x=x+delta(1);
   y=y+delta(2);
   set(p1,'xdata',x(1),'ydata',y(1));
   set(p2,'xdata',x(2),'ydata',y(2));
   pause(0.1),
   drawnow, %# I put this in case you take out the pause
end


end