%function z = subsample(Z,factor)
function z = subsample(Z,factor)

[r,c]=size(Z);
z=Z(1:factor:r,1:factor:c);

