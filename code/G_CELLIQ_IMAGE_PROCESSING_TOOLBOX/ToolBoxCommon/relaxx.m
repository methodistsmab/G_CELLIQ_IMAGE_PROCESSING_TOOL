function relaxx(data);

if nargin<1
	v=axis;
	data(1)=v(1);
	data(2)=v(2);
end;

h=max(data)-min(data);
xlim([min(data)-0.1*h,max(data)+0.1*h]);
