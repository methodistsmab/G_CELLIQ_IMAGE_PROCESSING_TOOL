%function [line,n,x]=kdeplot(data,binsize,sigma,str);
%
% Copyright 2001 Joakim Lindblad
function [line,n,x]=kdeplot(data,binsize,sigma,str);

[n,x]=kde(data,x_interval(data,binsize),sigma);
line=plot(x,n,str);

