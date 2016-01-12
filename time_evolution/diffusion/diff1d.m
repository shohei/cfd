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
global f1; global f2; global f3; global f4;
set(gcf, 'Position', [100, 100, 1000, 700]);

sp1=subplot(2,2,1);
title('Explicit / Dirichlet');
hold on;

sp2=subplot(2,2,3);
title('Explicit / Neumann');
hold on;

sp3=subplot(2,2,2);
title('Implicit / Dirichlet');
hold on;

sp4=subplot(2,2,4);
title('Implicit / Neumann');
hold on;

drawAll();

    function drawAll()
        for t=0:deltaT:tmax
            axes(sp1);
            h1=drawOne(t);
            axes(sp2);
            h2=drawTwo(t);
            axes(sp3);
            h3=drawThree(t);
            axes(sp4);
            h4=drawFour(t);
            drawnow;
            if (t==0)||(t==1)||(t==2)||(t==3)||(t==4)
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

    function h=drawOne(t)
        if t==0
            f1=A*(x>-width/2 & x<width/2);
        else
            % Dirichlet condition
            f_next(1) = 0;
            f_next(partition) = 0;
            for idx=2:partition-1
                f_next(idx) = f1(idx) + d*(f1(idx+1)-2*f1(idx)+f1(idx-1));
            end
            f1 = f_next;
        end
        subplot(221);
        h=plot(x,f1,'b-');
        xlim([-xmax xmax]);
        ylim([0 1.2*A]);
    end

    function h=drawTwo(t)
        if t==0
            f2=A*(x>-width/2 & x<width/2);
        else
            % Dirichlet condition
            f_next(1) = f2(2);
            f_next(partition) = f2(end-1);
            for idx=2:partition-1
                f_next(idx) = f2(idx) + d*(f2(idx+1)-2*f2(idx)+f2(idx-1));
            end
            f2 = f_next;
        end
        subplot(223);
        h=plot(x,f2,'b-');
        xlim([-xmax xmax]);
        ylim([0 1.2*A]);
    end


    function h=drawThree(t)
        if t==0
            f3=A*(x>-width/2 & x<width/2);
        else
            f_next = computeThomasMethod1(f3);
            f3 = f_next;
        end
        subplot(222);
        h=plot(x,f3,'b-');
        xlim([-xmax xmax]);
        ylim([0 1.2*A]);
    end

    function h=drawFour(t)
        if t==0
            f4=A*(x>-width/2 & x<width/2);
        else
            f_next = computeThomasMethod2(f4);
            f4 = f_next;
        end
        subplot(224);
        h=plot(x,f4,'b-');
        xlim([-xmax xmax]);
        ylim([0 1.2*A]);
    end

    function makeTitle()
        axes('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
        h=text(0.5, 0.98,'\bf 1D DIFFUSION','HorizontalAlignment','center','VerticalAlignment', 'top');
        h.FontSize = 14;
        h.Color = 'blue';
    end

    function f=computeThomasMethod1(b)
        p(1) = 1+2*d;
        q(1) = b(1);
        N = length(b);
        for idx=2:N
            p(idx) = (1+2*d) - d^2/p(idx-1);
            q(idx) = b(idx) + d*q(idx-1)/p(idx-1);
        end
        %         f(N) = q(N)/p(N);
        f(N) = b(N);
        for idx=N-1:-1:1
            f(idx)=(q(idx)+d*b(idx+1))/p(idx);
        end
    end

    function f=computeThomasMethod2(b)
        p(1) = 1+2*d;
        q(1) = b(1);
        p(2) = -d+(1+2*d);
        q(2) = b(2);
        N = length(b);
        for idx=3:N
            p(idx) = (1+2*d) - d^2/p(idx-1);
            q(idx) = b(idx) + d*q(idx-1)/p(idx-1);
        end
        f(N) = b(N-1);
        for idx=N-1:-1:2
            f(idx)=(q(idx)+d*b(idx+1))/p(idx);
        end
        f(1) = f(2);
    end


end