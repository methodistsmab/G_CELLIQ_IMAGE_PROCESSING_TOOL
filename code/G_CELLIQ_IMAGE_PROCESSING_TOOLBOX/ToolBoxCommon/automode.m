%function mode=automode(data)
%
%Tries to guess if the image contains dark objects on a bright background (1)
%or if the image contains bright objects on a dark background (-1)
%or if it contains both dark and bright objects on a gray background (0)
%
% Copyright 2001 Joakim Lindblad

function mode=automode(data)

pct=prctile(data(:),[1,20,80,99]);

upper=pct(4)-pct(3);
mid=pct(3)-pct(2);
lower=pct(2)-pct(1);

if (upper>mid) %upper objects
	uo=1;
else
	uo=0;
end;

if (lower>mid) %lower objects
	lo=1;
else
	lo=0;
end;

if (uo)
	if (lo)
		mode=0;	%both upper and lower objects
	else
		mode=-1;	%only upper objects
	end;
else				%no upper objects
	if (lo)
		mode=1;	%only lower objects
	else
		mode=0;	%no objects at all
	end;
end;
