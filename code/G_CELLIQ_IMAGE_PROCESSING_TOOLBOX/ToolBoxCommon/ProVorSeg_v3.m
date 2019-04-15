function LabMat = ProVorSeg_v3( SeedImg, OriImg, BwImg)
%%% use the CellProfiler's method.
warning off;
% SeedImg = im2bw( SeedImg, .5);
% SeedImg = bwlabel( SeedImg);
%regularization factor (0 to infinity). Larger=distance,0=intensity
%defaultVAR10 = 0.05
% RegularizationFactor = 0.05;
RegularizationFactor = 0.1;
LabMat = IdentifySecPropagateSubfunction(SeedImg,OriImg,BwImg,RegularizationFactor);