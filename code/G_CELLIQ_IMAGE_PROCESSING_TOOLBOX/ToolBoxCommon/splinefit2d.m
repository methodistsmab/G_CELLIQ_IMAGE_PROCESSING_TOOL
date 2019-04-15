%function pz = splinefit2d(x,y,z,px,py[,mask])
%
% Make a least squares fit of the spline (px,py,pz) to the surface (x,y,z)
%  If mask is give, only masked points are used for the regression
%
% Copyright 2001 Joakim Lindblad

function pz = splinefit2d(x,y,z,px,py,mask)

% Solve least squares problem
% See evalspline2d
%	z(:).'=pz(:).'*V => z(:).'/V=pz(:).'

if (nargin<6)
	V=spline_matrix2d(x,y,px,py);
	pz=z(:).'/V;
else
	% With mask
	V=spline_matrix2d(x,y,px,py,mask);
	pz=z(find(mask)).'/V;
end

pz=reshape(pz,length(py),length(px));
