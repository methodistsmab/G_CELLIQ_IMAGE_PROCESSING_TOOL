%function v=firstval(list, n=1)
% first n values in list
%
% JL 2000-07-08

function v=firstval(list,n)
if nargin<2
	v=list(1);
else
	v=list(1:n);
end

