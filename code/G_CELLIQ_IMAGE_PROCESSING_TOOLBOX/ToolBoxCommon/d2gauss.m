%function y = d2gauss(x,my,sigma)
%returns the second derivative of the gaussian with mean my and 
%stddev sigma calculated at the points of x
% JL 1999-11-15

function y = d2gauss(x,my,sigma)

%y=1/(sigma*sqrt(2*pi))*exp((- (x-my).^2)/(2*sigma^2));
%y=gauss(x,my,sigma).*(-(x-my)./(sigma^2));
y=gauss(x,my,sigma).*(-1/sigma^2 + (x-my).^2./sigma^4);
