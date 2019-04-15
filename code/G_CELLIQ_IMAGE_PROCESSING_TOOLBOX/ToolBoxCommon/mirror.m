%function y=mirror(x);
% x=a,a+b,a+2b,... => y=...,a-2b,a-b,a,a+b,a+2b,...

function y=mirror(x);

n=length(x);
xx=x(1)-reverse(x(2:n)-x(1));
y=[xx,x];

