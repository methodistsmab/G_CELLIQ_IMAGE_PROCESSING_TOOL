%function y = gauss(x,my,sigma)
%returns the gaussian with mean my and stddev sigma
%calculated at the points of x
% JL 1999-08-18

function y = gauss(x,my,sigma)
y=1./(sigma.*sqrt(2*pi))*exp((1./(2*sigma.^2)*(- (x-my).^2)));
