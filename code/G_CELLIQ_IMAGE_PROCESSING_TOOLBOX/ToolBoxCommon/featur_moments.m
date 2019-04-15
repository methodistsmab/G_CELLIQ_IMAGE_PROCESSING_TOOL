%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006
%%% First version is based on Jun Yan's version, which extracts 12
%%% features; But partial of the features are intensity related, instead of
%%% geometric feature;
%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)


function FMO=featur_moments(I)


D=12;

fig=figure;
[C,ch]=contour(I,[0,0],'r');
C(:,C(1,:)==0)=[];
delete(fig);
bw=roipoly(I,C(1,:),C(2,:));
STATS = regionprops(uint8(bw),'all');

R=STATS.MajorAxisLength;

[znames, zvalues] = mb_zernike(I,D,R);

FMO=reshape(zvalues,[length(zvalues) 1]);

