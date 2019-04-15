%function y = d2spline_factors(u)
%Second derivative of spline_factors
function y = d2spline_factors(u)

y=[ 1-u , -2+3.*u , 1-3.*u , u];
