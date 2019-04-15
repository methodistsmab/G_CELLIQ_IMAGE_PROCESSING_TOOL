%function y = evalspline(x,px,py[,mask])
%
% Calculate y values of the spline (px,py) at the points x
% If mask is given, points are evaluated only at mask positions,
% the rest is set to zero
%
% Copyright 2001 Joakim Lindblad

function y = evalspline(x,px,py,mask)

if ~isequal(size(px),size(py))
    error('px and py vectors must be the same size.')
end

if (nargin<4) % no mask
	V=spline_matrix(x,px);
	y=py * V;
else %mask
	V=spline_matrix(x,px,mask);
	y=zeros(size(mask));
	y(find(mask))=py * V;
end
