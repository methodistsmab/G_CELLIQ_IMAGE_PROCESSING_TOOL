%function V = spline_matrix2d(x,y,px,py[,mask])
% Construct 2d Vandermonde spline matrix.

%For boundary constraints, the not-a-knot condition is used by default.
%This means that the first two spline pieces are constrained to be part of
%the same cubic curve, as are the last two pieces.
%
% Copyright 2001 Joakim Lindblad

function V = spline_matrix2d(x,y,px,py,mask)

V=kron(spline_matrix(x,px),spline_matrix(y,py));

if (nargin<5) %no mask
	return;
else
	V=V(:,find(mask));
end;

