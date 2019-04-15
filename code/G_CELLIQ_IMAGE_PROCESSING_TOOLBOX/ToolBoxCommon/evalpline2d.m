function z = evalpline2d(x,y,px,py,pz,mask)
%function z = evalpline2d(x,y,px,py,pz[,mask])
%
% If mask is given, points are evaluated only at mask positions,
% the rest is set to zero
%
% Copyright 2001 Joakim Lindblad

if (nargin<6) % no mask
	V=pline_matrix2d(x,y,px,py);
	z=reshape(pz(:).'*V,length(y),length(x));
else %mask
	V=pline_matrix2d(x,y,px,py,mask);
	z=zeros(size(mask));
	z(find(mask))=pz(:).'*V;
end


