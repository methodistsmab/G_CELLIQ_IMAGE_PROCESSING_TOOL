%function h=h_rot(data)
%Rule of thumb selection of sigma for kde
%
% Copyright 2001 Joakim Lindblad

function h=h_rot(data)

data=data(:);
n=length(data);

percentiles=prctile(data,[25,75]);
R=percentiles(2)-percentiles(1);

h=1.06 * min(std(data),R/1.34) * n^(-1/5);
