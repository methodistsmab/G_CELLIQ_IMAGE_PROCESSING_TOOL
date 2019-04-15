function relaxy(data);

if nargin<1
	v=axis;
	data(1)=v(3);
	data(2)=v(4);
end;

h=max(data)-min(data);
ylim([min(data)-0.1*h,max(data)+0.1*h]);
