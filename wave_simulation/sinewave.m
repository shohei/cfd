function sinewave

clear all; close all;

x=linspace(0,10,101);
ylim([-1,1]);


for t=linspace(0,10,301)
  plot(x,sin(x-3*t));
  drawnow;
end

end