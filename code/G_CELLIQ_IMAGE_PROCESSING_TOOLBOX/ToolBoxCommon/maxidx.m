function i=maxidx(x,d)
if nargin>1
	[y,i]=max(x,[],d);
else
	[y,i]=max(x);
end
