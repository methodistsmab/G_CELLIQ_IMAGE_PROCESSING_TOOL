%function x=first_max(y)
%return index of the first local maximum
%(including the global ones, i.e. going down at edges)
%If max is wider than one, idx to the first position is returned

function x=first_max(y)

f=find(diff(y)<0);

if (length(f)==0)
	x=length(y);
else
	x=firstval(f);
end;
