function laplace2d

clear all;
close all;

Xobs = 0.8;
WobsX = 0.4;
WobsY = 0.5;
L = 2;
W = 1;
deltaX = 100;
deltaY = deltaX*W/2;
x=linspace(0,L,deltaX);
y=linspace(0,W,deltaY);
[X,Y] = meshgrid(x,y);
Psi = zeros(size(X));
U = 1.0;
iteration=5000;
tolerance=0.000001;

initStreamFunction();
computeGaussSeidelMethod();
contour(X,Y,Psi,'LineColor','blue');

    function initStreamFunction()
        for xidx=1:size(X,2)
            for yidx=1:size(Y,1)
                if(X(yidx,xidx) > Xobs-WobsX/2 && X(yidx,xidx) < Xobs+WobsX/2 && Y(yidx,xidx) < WobsY)
                    continue;
                else
                    Psi(yidx,xidx) = U*yidx;
                end
            end
        end
    end

    function computeGaussSeidelMethod()
        maxError=0.0;
        cnt=0;
        while(cnt<iteration)
            for xidx=2:size(X,2)-1
                for yidx=2:size(Y,1)-1
                    if(X(yidx,xidx) > Xobs-WobsX/2 && X(yidx,xidx) < Xobs+WobsX/2 && Y(yidx,xidx) < WobsY)
                        continue;
                    else
                        psi_d = (deltaY)^2*(Psi(yidx,xidx-1)+Psi(yidx,xidx+1))+...
                             (deltaX)^2*(Psi(yidx-1,xidx)+Psi(yidx+1,xidx));
                        psi_n = 2*((deltaX)^2+(deltaY)^2);
                        psi = psi_d/psi_n;                        
                        error = Psi(yidx,xidx) - psi;
                        if error > maxError
                            maxError = error;
                        end
                        Psi(yidx,xidx) = psi;                     
                    end
                end
            end
            
            if(maxError<tolerance)
                break;
            end
            cnt=cnt+1;
        end
    end

end