%function py = splinefit(x,y,px[,mask])
%
% Make a least squares fit of the spline (px,py) to the curve (x,y)
%
% Copyright 2001 Joakim Lindblad

function py = splinefit(x,y,px,mask)

if ~isequal(size(x),size(y))
    error('x and y vectors must be the same size.')
end

if (nargin<4) %no mask

%Spline basis matrix
V=spline_matrix(x,px);

% Solve least squares problem
% See evalspline
%	y=py*V => y/V=py

py=y/V;

% Matlab: help mrdivide and mldivide
%    B/A=(A'\B')'
%
%    If A is an M-by-N matrix with M < or > N and B is a column
%    vector with M components, or a matrix with several such columns,
%    then X = A\B is the solution in the least squares sense to the
%    under- or overdetermined system of equations A*X = B. The
%    effective rank, K, of A is determined from the QR decomposition
%    with pivoting. A solution X is computed which has at most K
%    nonzero components per column. If K < N this will usually not
%    be the same solution as PINV(A)*B.  A\EYE(SIZE(A)) produces a
%    generalized inverse of A.

else
	% With mask
	V=spline_matrix(x,px,mask);
	py=y(find(mask))/V;
end


