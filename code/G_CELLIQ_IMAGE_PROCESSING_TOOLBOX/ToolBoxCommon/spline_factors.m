%function y = spline_factors(u)
function y = spline_factors(u)

y=1/6.*[(1-u).^3 , 4-6.*u.^2+3*u.^3 , 1+3.*u+3.*u.^2-3.*u.^3 , u.^3];
