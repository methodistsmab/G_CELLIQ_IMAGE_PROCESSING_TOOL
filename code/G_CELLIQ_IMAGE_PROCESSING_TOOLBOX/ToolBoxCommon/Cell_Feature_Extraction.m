%%% Geometric Feature Extraction
%%% Created Jan. 24, 2006

%%  Last updated Jan. 24, 2006
%%% Jun Wang (jwang@bwh.harvard.edu)


function [FG, FECDF, FGEO, FMO, FTEX, FSC]=Cell_Feature_Extraction(CellPatchI)



[m n]=size(CellPatchI);
% I=zeros(max(m,n));
% if m<n
%     I(round(n/2-m/2):round(n/2-m/2)+m,:)=CellPatchI;
%     CellPatchI=I;
% elseif m>n
%     I(:,round(m/2-n/2):round(m/2-n/2)+n-1)=CellPatchI;
%     CellPatchI=I;
% end

% new_I=zeros(length(CellPatchI)+4);
% new_I(3:length(new_I)-2,3:length(new_I)-2)=CellPatchI;
% CellPatchI=uint8(new_I);


%%%parameters for Gabor feature extraction
freq=[0.05 0.4];
stage=5;
orientation=7;
flag=0;
%%%Gabor feature extraction
FG   = feature_gabor(CellPatchI, length(CellPatchI), freq, stage, orientation,flag);
FECDF=feature_CDF97(CellPatchI);
FGEO = featur_geometry(CellPatchI);
FMO  = featur_moments(CellPatchI);
FMO  = abs(FMO);
%FTEX = [];
FTEX = featur_texture(CellPatchI);
FSC  = featur_shapedis(CellPatchI);