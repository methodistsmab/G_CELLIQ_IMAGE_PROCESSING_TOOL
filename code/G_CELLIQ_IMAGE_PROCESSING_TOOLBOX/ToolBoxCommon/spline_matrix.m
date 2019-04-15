%function V = spline_matrix(x,px[,mask])
% Construct Vandermonde (blending) spline matrix.
%
%For boundary constraints, the not-a-knot condition is used by default.
%This means that the first two spline pieces are constrained to be part of
%the same cubic curve, as are the last two pieces.
%
% Copyright 2001 Joakim Lindblad

function V = spline_matrix(x,px,mask)

n=length(px);
lx=length(x);

j=pick(px,x)-1; % px(j)<=x(k)<px(j+1)
j=confine(j,1,n-1);
u=(x-px(j))./(px(j+1)-px(j)); % How far are we on the line segment px(j)->px(j+1), 0<=u<1

left=find(j==1);
j(left)=j(left)+1;
u(left)=u(left)-1;

right=find(j==n-1);
j(right)=j(right)-1;
u(right)=u(right)+1;

%positioning stuff
a=ones(lx,1)*(-1:2);
b=j.'*ones(1,4);
c=(0:lx-1).'*ones(1,4).*n;
d=a+b+c;
           
V=zeros(n,lx);
V(d)=spline_factors(u);

if (nargin<3) %no mask
	return;
else
	V=V(:,find(mask));
end;
