%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006
%%% First version is based on Xibao Zhou's version, which extracts 14 texture
%%% features;
%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)

function FTEX=featur_texture(I)



features = mb_texture(I);
FTEX=features(1:size(features,1)-1,1);