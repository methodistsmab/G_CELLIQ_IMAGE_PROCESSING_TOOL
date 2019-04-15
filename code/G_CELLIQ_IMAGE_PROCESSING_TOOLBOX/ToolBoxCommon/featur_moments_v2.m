%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006
%%% First version is based on Jun Yan's version, which extracts 12
%%% features; But partial of the features are intensity related, instead of
%%% geometric feature;
%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)
%%% updated by fuhai(robert.fh.li@gmail.com); May 23, 2007.
%%% step1: remove the 'contour' function which maybe cause the memory
%%% leaking
%%% step2: optimize the structure of the codes.


function FMO=featur_moments_v2(I)

warning off;

D=12;

% fig=figure;
% [C,ch]=contour(I,[0,0],'r');
% C(:,C(1,:)==0)=[];
% delete(fig);
% bw=roipoly(I,C(1,:),C(2,:));

bw = double((I>0));
STATS = regionprops(bw,'MajorAxisLength');
R= floor(STATS.MajorAxisLength);

[znames, zvalues] = mb_zernike(I,D,R);
FMO=reshape(zvalues,[length(zvalues) 1]);

