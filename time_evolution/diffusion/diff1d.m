function diff1d
clear all;
close all;

width=1;
A=1;
xmax=5;
partition=101;
x=linspace(-xmax,xmax,partition);
D=0.04;
dxs=diff(x);
dx=dxs(1);
deltaT=0.1;
d=D*deltaT/dx^2;
tmax=4;

set(gcf, 'Position', [100, 100, 1000, 700]);

subplot(221);
xlim([-xmax xmax]);
ylim([0 1.2*A]);
title('Explicit, Dirichlet');
makeTitle();
hold on;
for t=0:deltaT:tmax
    if t==0
        f=A*(x>-width/2 & x<width/2);        
    else
        % Dirichlet condition
        f_next(1) = 0;
        f_next(partition) = 0;
        for idx=2:partition-1
            f_next(idx) = f(idx) + d*(f(idx+1)-2*f(idx)+f(idx-1));
        end
        f = f_next;        
    end
    subplot(221);
    h=plot(x,f);
    xlim([-xmax xmax]);
    ylim([0 1.2*A]);
    drawnow;
    set(h,'Visible','off');
end


% subplot(223);
% f=A*(x>-d/2 & x<d/2);
% h = plot(x,f);
subplot(223);
xlim([-xmax xmax]);
ylim([0 1.2*A]);
title('Explicit, Neumann');
makeTitle();
hold on;
for t=0:deltaT:tmax
    if t==0
        f=A*(x>-d/2 & x<d/2);
    else
        % Dirichlet condition
        f_next(1) = f(2);
        f_next(partition) = f(end-1);
        for idx=2:partition-1
            f_next(idx) = f(idx) + d*(f(idx+1)-2*f(idx)+f(idx-1));
        end
        f = f_next;
    end
    subplot(223);
    h=plot(x,f);
    xlim([-xmax xmax]);
    ylim([0 1.2*A]);
    drawnow;
    set(h,'Visible','off');
end



subplot(222);
fx=A*(x>-d/2 & x<d/2);
plot(x,fx);
xlim([-xmax xmax]);
ylim([0 1.2*A]);
title('Implicit, Dirichlet');
makeTitle();





subplot(224);
fx=A*(x>-d/2 & x<d/2);
plot(x,fx);
xlim([-xmax xmax]);
ylim([0 1.2*A]);
title('Implicit, Neumann');
makeTitle();


    function makeTitle()
        axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        h=text(0.5, 0.98,'\bf 1D DIFFUSION','HorizontalAlignment','center','VerticalAlignment', 'top');
        h.FontSize = 14;
        h.Color = 'blue';
    end



end