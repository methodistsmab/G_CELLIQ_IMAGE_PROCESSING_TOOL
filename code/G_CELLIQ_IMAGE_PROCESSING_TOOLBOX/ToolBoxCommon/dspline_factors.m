%function y = dspline_factors(u)
%First derivative of spline_factors
function y = dspline_factors(u)

y=1/6.*[ -3+6.*u-3.*u.^2 , -12.*u+9.*u.^2 , 3+6.*u-9.*u.^2 , 3.*u.^2];
