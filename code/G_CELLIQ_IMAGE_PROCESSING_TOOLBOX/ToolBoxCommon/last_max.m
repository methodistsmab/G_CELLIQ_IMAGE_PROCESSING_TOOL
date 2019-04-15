%function x=last_max(y)
%return indix of the last local maximum
%(including the global ones, i.e. going down at edges)

function x=last_max(y)

f=find(diff(y)>0);

if (length(f)==0)
	x=1;
else
	x=lastval(f)+1;
end;