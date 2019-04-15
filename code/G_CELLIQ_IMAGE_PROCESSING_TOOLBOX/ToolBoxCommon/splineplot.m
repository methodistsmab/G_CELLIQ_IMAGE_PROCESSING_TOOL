%function splineplot(x,y,px,py,pz);
function splineplot(x,y,px,py,pz,draw_points);

if nargin<6 draw_points=1; end;

z=evalspline2d(x,y,px,py,pz);
hidden off
[X,Y]=meshgrid(x,y);
mesh(x,y,z);

if (draw_points)
	hidden off
	hold on
	[X,Y]=meshgrid(px,py);
	mesh(X,Y,pz,zeros(size(pz)));
	plot3(X,Y,pz,'k.');
	hidden off
	hold off;
end