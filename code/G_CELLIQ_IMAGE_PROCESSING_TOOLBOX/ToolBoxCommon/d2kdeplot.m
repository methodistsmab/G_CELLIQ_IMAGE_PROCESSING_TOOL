%function [line,n,x]=d2kdeplot(data,binsize,sigma,str);
%Plot of second derivative
function [line,n,x]=d2kdeplot(data,binsize,sigma,str);

[n,x]=d2kde(data,x_interval(data,binsize),sigma);
line=plot(x,2*n*sigma.^2,str);
