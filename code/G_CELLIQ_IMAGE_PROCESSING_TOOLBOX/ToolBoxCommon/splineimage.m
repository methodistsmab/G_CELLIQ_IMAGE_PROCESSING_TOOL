%function [px,py,pz] = splineimage(Z,points[,mask,x,y])

function [px,py,pz] = splineimage(Z,points,mask,x,y)

[r,c]=size(Z);

if (nargin<4)	x=1:c; end
if (nargin<5)	y=1:r; end

%spline control points, let the outer ones be outside the image
cstep=(x(end)-x(1))/(points-2-1);
px=linspace(x(1)-cstep,x(end)+cstep,points);
rstep=(y(end)-y(1))/(points-2-1);
py=linspace(y(1)-rstep,y(end)+rstep,points);

if (nargin<3)
        pz=splinefit2d(x,y,Z,px,py);
else
        pz=splinefit2d(x,y,Z,px,py,mask);
end


