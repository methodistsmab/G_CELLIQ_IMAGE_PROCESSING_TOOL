%function [res,bg]=bg_compensate(file,sigma='kde');
%
% reads file, subtracts background and saves
% 'img_bg_compensated.tif' (compensated image) and
% 'img_background.tif' (the subtracted background)
%
% Set sigma to 'kde' (default) for kde thresholding
% Set sigma to e.g. 1.7 for thresholding at 1.7 stddevs.
%
% Copyright 2001 Joakim Lindblad
% Fuhai Li ajusted Aug 14, 2006.

function [res,bg, cut]=bg_compensate_v2(img,sigma);

if nargin<2
	sigma='kde';
end;

img=double(img);
if length(size(img))>2
	error('Image must be grayscale');
end

scale=ceil(length(img)/200);
sub=subsample(img,scale);   	%it's usually too big to handle

if strcmp(sigma,'kde')
	%disp('Using KDE thresholding');
	bgsub=kdebackgr(sub,'auto',5,0,scale);
else
	[bgsub, temp, cut]= backgr_v2(sub,'auto',sigma,5,0,scale);
end

bg=imresize(bgsub,size(img),'bicubic');

res=img-bg;

%imwrite(uint8(res),sprintf('%s_bg_compensated.tif',ext_cut(file)));
%imwrite(uint8(bg),sprintf('%s_background.tif',ext_cut(file)));
