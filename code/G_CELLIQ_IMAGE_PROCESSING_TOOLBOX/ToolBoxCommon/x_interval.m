%function x=x_interval(data,binsize);
% Creates x-axis vector which is 1.4*width(data)
% and has points at 'binsize' distance.
%
% Copyright 2001 Joakim Lindblad

function x=x_interval(data,binsize);

data=data(:); %make vector

minx=floor(min(data));
maxx=ceil(max(data));
w=maxx-minx; %width(data)

x = (minx-0.2*w:binsize:maxx+0.2*w);

