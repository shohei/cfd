function laplace2d_velocity_potential
clear all; close all;
format shortG;

%%define capture
CAPTURE = true;

global L;global U;global W;global Xobs;global WobsX;global WobsY;
L = 2.0;
U = 1.0;
W = 1.8;
Xobs= 1.0;
WobsX=0.2;
WobsY=0.7;
hold on;
drawDuct();
global Phi;
global deltaX; global deltaY;
global iteration; global tolerance;
iteration=5000;
tolerance=1e-5;
deltaX = 0.1;
deltaY = 0.1;
x = 0:deltaX:L;
y = 0:deltaY:W;
[X,Y] = meshgrid(x,y);
Phi = U*X+0*Y;

if(CAPTURE)
    writerObj = VideoWriter('velocity_potential.avi');
    open(writerObj);
end

initVelocityPotential();
% drawVelocityPotential();

computeGaussSeidelMethod();

if(CAPTURE)
    close(writerObj);
end
    function drawDuct()
        plot([0,Xobs-WobsX/2],[0,0],'k');
        plot([Xobs-WobsX/2,Xobs-WobsX/2],[0,WobsY],'k');
        plot([Xobs-WobsX/2,Xobs+WobsX/2],[WobsY,WobsY],'k');
        plot([Xobs+WobsX/2,Xobs+WobsX/2],[WobsY,0],'k');
        plot([Xobs+WobsX/2,L],[0,0],'k');
        plot([0,L],[W,W],'k')
        title('VELOCITY POTENTIAL OF FLOW IN DUCT');
    end

    function initVelocityPotential()
        for iidx=1:L/deltaX+1
            for jidx=1:W/deltaY+1
                pType = checkPointAttribute(iidx,jidx);
                switch(pType)
                    case 'OBSTACLE'
                        Phi(jidx,iidx)=0;
                    case 'LEFT'
                        Phi(jidx,iidx) = 0;
                    case 'RIGHT'
                        Phi(jidx,iidx) = U*L;
                    case 'BOTTOM'
                        Phi(jidx,iidx) = Phi(jidx+1,iidx);
                    case 'TOP'
                        Phi(jidx,iidx) = Phi(jidx-1,iidx);
                    case 'OBS_LEFT'
                        Phi(jidx,iidx) = Phi(jidx,iidx-1);
                    case 'OBS_TOP'
                        Phi(jidx,iidx) = Phi(jidx+1,iidx);
                    case 'OBS_RIGHT'
                        Phi(jidx,iidx) = Phi(jidx,iidx+1);
                    case 'CORNER_UPPER_LEFT'
                        Phi(jidx,iidx) = Phi(jidx-1,iidx-1);
                    case 'CORNER_UPPER_RIGHT'
                        Phi(jidx,iidx) = Phi(jidx+1,iidx+1);
                end
            end
        end
    end


    function computeGaussSeidelMethod()
        cnt=0;
        %         xmax=L/deltaX+1;
        %         ymax=W/deltaY+1;
        
        while(cnt<iteration)
            maxError=0.0;
            for iidx=1:L/deltaX+1
                for jidx=1:W/deltaY+1
                    
                    pType = checkPointAttribute(iidx,jidx);
                    switch(pType)
                        case 'OBSTACLE'
                            Phi(jidx,iidx)=0;
                        case 'INTERNAL'
                            pn = (deltaY)^2*(Phi(jidx,iidx-1)+Phi(jidx,iidx+1))+...
                                (deltaX)^2*(Phi(jidx-1,iidx)+Phi(jidx+1,iidx));
                            pd = 2*((deltaX)^2+(deltaY)^2);
                            pp = pn / pd;
                            error = abs(pp - Phi(jidx,iidx));
                            
                            if(error > maxError)
                                maxError = error;
                                %                                 fprintf('update maxError %.10f @ i=%d j=%d\n',...
                                %                                 maxError,iidx,jidx);
                                Phi(jidx,iidx) = pp;
                            end
                        case 'LEFT'
                            Phi(jidx,iidx) = 0;
                        case 'RIGHT'
                            Phi(jidx,iidx) = U*L;
                        case 'BOTTOM'
                            Phi(jidx,iidx) = Phi(jidx+1,iidx);
                        case 'TOP'
                            Phi(jidx,iidx) = Phi(jidx-1,iidx);
                        case 'OBS_LEFT'
                            Phi(jidx,iidx) = Phi(jidx,iidx-1);
                        case 'OBS_TOP'
                            Phi(jidx,iidx) = Phi(jidx+1,iidx);
                        case 'OBS_RIGHT'
                            Phi(jidx,iidx) = Phi(jidx,iidx+1);
                        case 'CORNER_UPPER_LEFT'
                            Phi(jidx,iidx) = Phi(jidx-1,iidx-1);
                        case 'CORNER_UPPER_RIGHT'
                            Phi(jidx,iidx) = Phi(jidx+1,iidx+1);
                    end
                end
            end
            
            %             maxError
            if(maxError<tolerance)
                cnt
                break;
            end
            cnt=cnt+1;
            
            cla;
            str = sprintf('timeframe %d',cnt);
            text(L-0.2,W+0.1,str);
            drawVelocityPotential()
            
        end
    end

    function attrib=checkPointAttribute(iidx,jidx)
        if (iidx>((Xobs-WobsX/2)/deltaX)+1)&&(iidx<((Xobs+WobsX/2)/deltaX)+1)&&...
                (jidx < (WobsY/deltaY)+1)
            attrib='OBSTACLE';
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'O');
            %                         drawnow;
        elseif (jidx==1)
            attrib='BOTTOM';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'bo');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'B');
            %                         drawnow;
        elseif (jidx==W/deltaY+1)
            attrib='TOP';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'bo');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'T');
            %                         drawnow;
        elseif (iidx==1)
            attrib='LEFT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'bo');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'L');
            %                         drawnow;
        elseif (iidx==L/deltaX+1)
            attrib='RIGHT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'bo');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'R');
            %                         drawnow;
        elseif (iidx==(Xobs-WobsX/2)/deltaX+1)&&(jidx<(WobsY/deltaY+1))
            attrib='OBS_LEFT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'go');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'O_L');
            %                         drawnow;
        elseif (iidx>((Xobs-WobsX/2)/deltaX+1))&&...
                (iidx<((Xobs+WobsX/2)/deltaX+1))&&...
                (jidx==(WobsY/deltaY)+1)
            attrib='OBS_TOP';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'go');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'O_T');
            %                         drawnow;
        elseif (iidx==(Xobs+WobsX/2)/deltaX+1)&&(jidx<(WobsY/deltaY+1))
            attrib='OBS_RIGHT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'go');
            %             text((iidx-1)*deltaX,(jidx-1)*deltaY,'O_R');
            %             drawnow;
        elseif (iidx==(Xobs-WobsX/2)/deltaX+1)&&(jidx==(WobsY/deltaY+1))
            attrib='CORNER_UPPER_LEFT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'ko');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'C_L');
            %                         drawnow;
        elseif (iidx==(Xobs+WobsX/2)/deltaX+1)&&(jidx==(WobsY/deltaY+1))
            attrib='CORNER_UPPER_RIGHT';
            %             plot((iidx-1)*deltaX,(jidx-1)*deltaY,'ko');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'C_R');
            %                         drawnow;
        else
            attrib='INTERNAL';
            %             plot(iidx*deltaX,jidx*deltaY,'ro');
            %                         text((iidx-1)*deltaX,(jidx-1)*deltaY,'I');
            %                         drawnow;
        end
    end


    function drawVelocityPotential()
        drawDuct();
        contour(X,Y,Phi,10,'LineColor','red');
        patch([Xobs-WobsX/2 Xobs-WobsX/2 Xobs+WobsX/2 Xobs+WobsX/2],...
            [0 WobsY WobsY 0],'k');
        drawnow limitrate;
        if(CAPTURE)
            frame = getframe(gcf);
            writeVideo(writerObj, frame);
        end
    end

end