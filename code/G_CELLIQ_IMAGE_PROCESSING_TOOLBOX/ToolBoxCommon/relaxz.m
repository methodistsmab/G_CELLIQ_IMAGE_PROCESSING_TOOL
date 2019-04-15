function relaxz(data);

if nargin<1
	v=axis;
	data(1)=v(5);
	data(2)=v(6);
end;

h=max(data)-min(data);
zlim([min(data)-0.1*h,max(data)+0.1*h]);
