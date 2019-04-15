%function p=pick(picklist,val)
% Index to first value in picklist that is larger than val
% If none is larger, index=length(picklist)
%
% Copyright 2001 Joakim Lindblad

function p=pick(picklist,val)

%jepp it's faster to zero first
p=zeros(1,length(val));
for i=1:length(val)
	pl=find(picklist>val(i));
	if (isempty(pl))
		p(i)=length(picklist); %pick the last if larger than all
	else
		p(i)=pl(1);
	end
end
